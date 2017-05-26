const Elm = require('./Main.elm')

const mountNode = document.getElementById('app-container')

require('./css/reset.css')
require('./css/style.css')

const app = Elm.Main.embed(mountNode)

let player
let done = false

function play() {
  done = false
  player = document.getElementById('audio-player')
  player.play()
}

function pause() {
  player.pause()
}

function timeupdateListener() {
  app.ports.progress.send({
    elapsed: player.currentTime,
    total: player.duration
  })

  if (!done) {
    requestAnimationFrame(timeupdateListener)
  }
}

function progress() {
  player.addEventListener('timeupdate', timeupdateListener, false)
}

function endedListener() {
  app.ports.ended.send({
    ended: true
  })
}

function ended() {
  player.addEventListener('ended', endedListener)
}

function reset() {
  if (player) {
    player.removeEventListener('timeupdate', timeupdateListener)
    player.removeEventListener('ended', endedListener)
  }

  done = true
}

app.ports.playAudio.subscribe(play)
app.ports.pauseAudio.subscribe(pause)
app.ports.trackProgress.subscribe(progress)
app.ports.trackEnded.subscribe(ended)
app.ports.reset.subscribe(reset)
