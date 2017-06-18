const Elm = require('./Main.elm')

const mountNode = document.getElementById('app-container')

require('./css/reset.css')
require('./css/style.css')

const app = Elm.Main.embed(mountNode)

// AUDIO
let player
let playerId
let done = false

function play(id) {
  done = false
  playerId = id
  player = document.getElementById('audio-player-' + id)
  player.play()
}

function pause() {
  player.pause()
}

function timeupdateListener() {
  app.ports.progress.send({
    id: playerId,
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
    id: playerId,
    ended: true
  })
}

function ended() {
  player.addEventListener('ended', endedListener)
}

function reset() {
  if (player) {
    player.load()
    player.removeEventListener('timeupdate', timeupdateListener)
    player.removeEventListener('ended', endedListener)
  }

  done = true
}

// MARKDOWN
function loadMarkdownFile(file) {
  const req = new XMLHttpRequest()

  req.open('GET', 'blurbs/' + file, true)

  req.onload = () => {
    if (req.status >= 200 && req.status < 400) {
      app.ports.receiveMarkdownFile.send(req.responseText)
    } else {
      console.log('error')
    }
  }

  req.onerror = () => {
    console.log('error')
  }

  req.send()
}

app.ports.playAudio.subscribe(play)
app.ports.pauseAudio.subscribe(pause)
app.ports.trackProgress.subscribe(progress)
app.ports.trackEnded.subscribe(ended)
app.ports.reset.subscribe(reset)
app.ports.loadMarkdownFile.subscribe(loadMarkdownFile)
