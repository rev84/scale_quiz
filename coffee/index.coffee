window.currentQuestion = null
window.questionCount = 0
window.correctCount = 0
window.score = 0
window.questions = []
window.refreshTimer = null
window.audios = {}

$().ready ->
  $('#start').on 'click', startGame

  $('.alt').on 'click', ->
    answer Number $(@).data('answer')

  initAudio()

startGame = ->
  $('#question_start').addClass 'no_display' unless $('#question_start').hasClass 'no_display'
  $('#question_body').removeClass 'no_display' if $('#question_body').hasClass 'no_display'
  window.currentQuestion = null
  window.questionCount = 0
  window.correctCount = 0
  window.score = 0
  window.questions = Utl.shuffle Utl.clone window.QUESTION_BASE
  startQuestion()

startQuestion = ->
  q = window.questions.pop()

  q.started = +(new Date())
  q.fontSize = 0.8 * Utl.getFillFontSize $('#question_text'), q.question

  window.currentQuestion = q
  window.questionCount++
  startTimer 100


answer = (answerId)->
  return if window.currentQuestion is null

  if answerId is window.currentQuestion.answer
    play 'correct'
    alert '正解'
  else
    play 'wrong'
    alert '不正解'
  startQuestion()

refresh = ->
  $('#status_count').html('第'+window.questionCount+'問')
  if window.currentQuestion isnt null
    restSec = Math.floor((+new Date()) - window.currentQuestion.started) / 1000
    $('#status_timer').html(restSec+'秒')

  if window.currentQuestion is null
    $('#question_text').html('')
    $('#question_plus').html('')
  else
    $('#question_text').html(window.currentQuestion.question).css('font-size', ''+window.currentQuestion.fontSize+'px')
    $('#question_plus').html(window.currentQuestion.plus)

stopTimer = ->
  clearInterval window.refreshTimer if window.refreshTimer isnt null
  window.refreshTimer = null

startTimer = (ms = 1000)->
  stopTimer()
  window.refreshTimer = setInterval refresh, ms

onResize = ->
  if window.currentQuestion isnt null
    window.currentQuestion.fontSize = 0.8 * Utl.getFillFontSize $('#question_body'), window.currentQuestion.question

initAudio = ->
  for name, body of window.RESOURCES.wav
    window.audios[name] = []
    for index in [0...5]
      window.audios[name].push new Audio(body)

play = (resource)->
  while window.audios[resource].length > 0
    aud = window.audios[resource].shift()
    window.audios[resource].push new Audio(window.RESOURCES.wav[resource]) 
    if aud.readyState is 4
      aud.play()
      return
