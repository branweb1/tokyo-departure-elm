const Elm = require('./Main.elm')

const mountNode = document.getElementById('main')

require('./css/reset.css')
require('./css/style.css')

const app = Elm.Main.embed(mountNode)

function play() {
  const player = document.getElementById('audio-player')
  player.play()
}

function pause() {
  const player = document.getElementById('audio-player')
  player.pause()
}

function progress() {
  const player = document.getElementById('audio-player')

  player.addEventListener('timeupdate', () => {
    function updateProgress() {
      requestAnimationFrame(updateProgress)

      app.ports.progress.send({
        elapsed: player.currentTime,
        total: player.duration
      })
    }

    requestAnimationFrame(updateProgress)
  })
}

function ended() {
  const player = document.getElementById('audio-player')

  player.addEventListener('ended', () => {
    app.ports.ended.send({
      ended: true
    })
  })
}

app.ports.playAudio.subscribe(play)
app.ports.pauseAudio.subscribe(pause)
app.ports.trackProgress.subscribe(progress)
app.ports.trackEnded.subscribe(ended)
