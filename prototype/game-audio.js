(() => {
  const settingsKey = "enviromentAll.settings";
  const sessionKey = "enviromentAll.musicSession";
  const menuTrack = "Threshold_of_the_Wild.mp3";
  const phaseTracks = [
    { first: 1, last: 2, file: "Bottles_In_Flight.mp3" },
    { first: 3, last: 4, file: "Where_the_River_Bends.mp3" },
    { first: 5, last: 6, file: "The_Final_Tally.mp3" },
    { first: 7, last: 8, file: "Beneath_the_Canopy.mp3" },
    { first: 9, last: 10, file: "Sentry_of_the_Ancient_Vale.mp3" },
    { first: 11, last: 15, file: "Path_Through_the_Ferns.mp3" }
  ];
  const musicFolder = "../assets/music/";
  let music;
  let activeTrack;
  let pendingPosition = 0;
  let audioContext;
  let lastSaveAt = 0;

  function readSettings() {
    try { return JSON.parse(localStorage.getItem(settingsKey) || "{}"); }
    catch { return {}; }
  }
  function readSession() {
    try { return JSON.parse(localStorage.getItem(sessionKey) || "null"); }
    catch { return null; }
  }
  function saveSession(track, position, playing) {
    if (!track) return;
    try {
      localStorage.setItem(sessionKey, JSON.stringify({
        track: track,
        position: Math.max(0, Number(position) || 0),
        playing: Boolean(playing),
        savedAt: Date.now()
      }));
    } catch { /* Continue with audio for the current page. */ }
  }
  function saveCurrentPlayback(playing) {
    if (!music || !activeTrack) return;
    saveSession(activeTrack, music.currentTime || pendingPosition, playing);
  }
  function phaseTrack(phase) {
    const match = phaseTracks.find((track) => phase >= track.first && phase <= track.last);
    return match ? match.file : null;
  }
  function selectTrack(session) {
    const page = window.location.pathname.split("/").pop().toLowerCase();
    if (page === "menu.html") return menuTrack;
    const phase = Number(new URLSearchParams(window.location.search).get("fase"));
    if (page === "phase-play.html" && phase >= 1 && phase <= 15) {
      if (!session || !session.track || session.track === menuTrack) return phaseTrack(phase);
    }
    return session && session.track ? session.track : phaseTrack(phase) || menuTrack;
  }
  function tryPlay() {
    if (!music || readSettings().musicOn === false) return;
    music.volume = Math.max(0, Math.min(1, Number(readSettings().musicVolume ?? 0.48)));
    music.play().then(() => saveCurrentPlayback(true)).catch(() => saveCurrentPlayback(false));
  }
  function startMusic() {
    const session = readSession();
    const track = selectTrack(session);
    if (readSettings().musicOn === false) {
      const position = session && session.track === track
        ? (music && activeTrack === track ? music.currentTime : session.position)
        : 0;
      saveSession(track, position, false);
      return;
    }
    if (music && activeTrack === track) {
      tryPlay();
      return;
    }

    const oldTrack = activeTrack;
    if (music) {
      saveCurrentPlayback(false);
      music.pause();
      music.removeAttribute("src");
      music.load();
    }
    activeTrack = track;
    const continues = Boolean(session && session.track === track && oldTrack !== track);
    pendingPosition = continues ? Number(session.position || 0) : 0;
    if (continues && session.playing) {
      const elapsed = Math.max(0, (Date.now() - Number(session.savedAt || Date.now())) / 1000);
      pendingPosition += elapsed;
    }
    music = new Audio();
    music.src = musicFolder + track;
    music.loop = true;
    music.preload = "auto";
    music.playsInline = true;
    music.volume = Math.max(0, Math.min(1, Number(readSettings().musicVolume ?? 0.48)));
    music.addEventListener("loadedmetadata", () => {
      if (!music || activeTrack !== track) return;
      const duration = Number(music.duration);
      if (Number.isFinite(duration) && duration > 0) pendingPosition %= duration;
      try { music.currentTime = pendingPosition; } catch { /* Wait for media metadata before resuming. */ }
      saveCurrentPlayback(false);
      tryPlay();
    }, { once: true });
    music.addEventListener("timeupdate", () => {
      const now = Date.now();
      if (now - lastSaveAt < 900) return;
      lastSaveAt = now;
      saveCurrentPlayback(!music.paused);
    });
    music.load();
    saveSession(track, pendingPosition, false);
  }
  function stopMusic() {
    if (!music) {
      const session = readSession();
      if (session) saveSession(session.track, session.position, false);
      return;
    }
    saveCurrentPlayback(false);
    music.pause();
  }
  function play(name) {
    if (name !== "click" || readSettings().soundOn === false) return;
    const Context = window.AudioContext || window.webkitAudioContext;
    if (!Context) return;
    if (!audioContext) audioContext = new Context();
    const oscillator = audioContext.createOscillator();
    const envelope = audioContext.createGain();
    const volume = Math.max(0, Math.min(1, Number(readSettings().effectsVolume ?? 75) / 100));
    const now = audioContext.currentTime;
    oscillator.type = "triangle";
    oscillator.frequency.setValueAtTime(780, now);
    oscillator.frequency.exponentialRampToValueAtTime(480, now + 0.045);
    envelope.gain.setValueAtTime(0.0001, now);
    envelope.gain.exponentialRampToValueAtTime(0.045 * volume, now + 0.006);
    envelope.gain.exponentialRampToValueAtTime(0.0001, now + 0.055);
    oscillator.connect(envelope);
    envelope.connect(audioContext.destination);
    oscillator.start(now);
    oscillator.stop(now + 0.06);
    if (audioContext.state === "suspended") audioContext.resume().catch(() => {});
  }
  function setSetting(name, value) {
    const settings = readSettings();
    settings[name] = value;
    try { localStorage.setItem(settingsKey, JSON.stringify(settings)); }
    catch { /* Continue with audio for the current page. */ }
    if (name === "musicOn") value ? startMusic() : stopMusic();
    return value;
  }
  function unlock() {
    if (audioContext && audioContext.state === "suspended") audioContext.resume().catch(() => {});
    if (readSettings().musicOn !== false) startMusic();
  }

  window.EnviromentAudio = { play, startMusic, stopMusic, setSetting, readSettings };
  document.addEventListener("pointerdown", unlock);
  document.addEventListener("keydown", unlock);
  document.addEventListener("click", (event) => {
    if (event.target.closest("button, a, summary, input, select, [role=\"button\"]")) play("click");
  });
  window.addEventListener("pagehide", () => saveCurrentPlayback(music && !music.paused));
  document.addEventListener("visibilitychange", () => {
    if (document.hidden) {
      saveCurrentPlayback(false);
      if (music) music.pause();
      return;
    }
    unlock();
  });
  startMusic();
})();
