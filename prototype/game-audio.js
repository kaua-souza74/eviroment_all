(() => {
  const settingsKey = "enviromentAll.settings";
  const melody = [523.25, 659.25, 783.99, 659.25, 587.33, 698.46, 880, 698.46, 523.25, 659.25, 783.99, 987.77, 880, 783.99, 659.25, 587.33];
  let audioContext;
  let effectsBus;
  let musicBus;
  let musicTimer;
  let musicStep = 0;
  const pendingSounds = [];

  function readSettings() {
    try { return JSON.parse(localStorage.getItem(settingsKey) || "{}"); }
    catch { return {}; }
  }
  function writeSettings(values) {
    try { localStorage.setItem(settingsKey, JSON.stringify(values)); }
    catch { /* Audio stays available for the current page if storage is unavailable. */ }
  }
  function context() {
    if (audioContext) return audioContext;
    const Context = window.AudioContext || window.webkitAudioContext;
    if (!Context) return null;
    audioContext = new Context();
    effectsBus = audioContext.createGain();
    musicBus = audioContext.createGain();
    effectsBus.connect(audioContext.destination);
    musicBus.connect(audioContext.destination);
    syncVolume();
    return audioContext;
  }
  function syncVolume() {
    if (!audioContext || !effectsBus || !musicBus) return;
    const settings = readSettings();
    effectsBus.gain.setTargetAtTime((Number(settings.effectsVolume ?? 75) / 100) * 0.42, audioContext.currentTime, 0.04);
    musicBus.gain.setTargetAtTime(settings.musicOn === false ? 0 : 0.12, audioContext.currentTime, 0.12);
  }
  function tone(frequency, startAt, duration, wave, volume, bus, endFrequency) {
    const ctx = context();
    if (!ctx || !bus) return;
    const oscillator = ctx.createOscillator();
    const envelope = ctx.createGain();
    oscillator.type = wave || "sine";
    oscillator.frequency.setValueAtTime(frequency, startAt);
    if (endFrequency) oscillator.frequency.exponentialRampToValueAtTime(endFrequency, startAt + duration);
    envelope.gain.setValueAtTime(0.0001, startAt);
    envelope.gain.exponentialRampToValueAtTime(Math.max(0.0002, volume), startAt + Math.min(0.025, duration * 0.22));
    envelope.gain.exponentialRampToValueAtTime(0.0001, startAt + duration);
    oscillator.connect(envelope);
    envelope.connect(bus);
    oscillator.start(startAt);
    oscillator.stop(startAt + duration + 0.015);
  }
  function play(name) {
    const settings = readSettings();
    if (settings.soundOn === false) return;
    const ctx = context();
    if (!ctx) return;
    const sound = () => {
      if (name === "victory") {
        [523.25, 659.25, 783.99, 1046.5].forEach((note, index) => {
          tone(note, ctx.currentTime + index * 0.12, 0.42, "triangle", 0.16, effectsBus);
          if (index === 3) tone(note * 1.5, ctx.currentTime + index * 0.12, 0.34, "sine", 0.055, effectsBus);
        });
      } else if (name === "correct" || name === "drop") {
        const notes = name === "drop" ? [440, 659.25] : [587.33, 783.99];
        notes.forEach((note, index) => tone(note, ctx.currentTime + index * 0.075, 0.2, "triangle", 0.105, effectsBus));
      } else if (name === "wrong") {
        tone(300, ctx.currentTime, 0.16, "sawtooth", 0.055, effectsBus, 210);
      } else if (name === "coin") {
        tone(987.77, ctx.currentTime, 0.14, "sine", 0.08, effectsBus);
        tone(1318.5, ctx.currentTime + 0.075, 0.22, "sine", 0.07, effectsBus);
      } else if (name === "click") {
        tone(740, ctx.currentTime, 0.065, "sine", 0.045, effectsBus, 930);
      } else if (name === "leaf") {
        tone(660, ctx.currentTime, 0.32, "sine", 0.045, effectsBus, 440);
      }
    };
    if (ctx.state === "suspended") {
      pendingSounds.push(sound);
      ctx.resume().then(() => {
        const queued = pendingSounds.splice(0);
        queued.forEach((playSound) => playSound());
      }).catch(() => {});
    } else sound();
  }
  function startMusic() {
    const settings = readSettings();
    if (settings.musicOn === false || musicTimer) return;
    const ctx = context();
    if (!ctx) return;
    ctx.resume().then(() => {
      if (readSettings().musicOn === false || musicTimer) return;
      syncVolume();
      musicStep = 0;
      musicTimer = window.setInterval(() => {
        if (document.hidden || !musicBus) return;
        const now = ctx.currentTime + 0.025;
        const note = melody[musicStep % melody.length];
        tone(note, now, 0.32, "triangle", 0.42, musicBus);
        if (musicStep % 4 === 0) tone(note / 2, now, 0.55, "sine", 0.34, musicBus);
        if (musicStep % 8 === 4) tone(note * 1.25, now, 0.42, "sine", 0.12, musicBus);
        musicStep++;
      }, 430);
    }).catch(() => {});
  }
  function stopMusic() {
    if (musicTimer) window.clearInterval(musicTimer);
    musicTimer = null;
    if (audioContext && musicBus) musicBus.gain.setTargetAtTime(0, audioContext.currentTime, 0.04);
  }
  function setSetting(name, value) {
    const settings = readSettings();
    settings[name] = value;
    writeSettings(settings);
    syncVolume();
    if (name === "musicOn") value ? startMusic() : stopMusic();
    return value;
  }
  function unlock() {
    const ctx = context();
    if (!ctx) return;
    if (ctx.state === "suspended") ctx.resume().then(() => {
      const queued = pendingSounds.splice(0);
      queued.forEach((playSound) => playSound());
      syncVolume();
      if (readSettings().musicOn !== false) startMusic();
    }).catch(() => {});
    else if (readSettings().musicOn !== false) startMusic();
  }

  window.EnviromentAudio = { play, startMusic, stopMusic, setSetting, readSettings };
  document.addEventListener("pointerdown", unlock);
  document.addEventListener("keydown", unlock);
  document.addEventListener("click", (event) => {
    if (event.target.closest("button, a, summary")) play("click");
  });
  document.addEventListener("visibilitychange", () => {
    if (document.hidden && audioContext?.state === "running") audioContext.suspend().catch(() => {});
    else if (!document.hidden) unlock();
  });
  startMusic();
})();
