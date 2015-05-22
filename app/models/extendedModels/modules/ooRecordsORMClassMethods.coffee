redis = require 'redis'
Promise = require 'promise'

OORecordsORM =

  moduleName: "OORecordsORM"

  moduleInitialise: ->
    @client = redis.createClient()

  createSession: (url) ->
    @client.sadd 'activeUrls', url
    # if time
    #   setTimeout @finishSession, time, url

  # finishSession: (url) ->
  #   console.log("this url will be deleted:", url)

  addQuestion: (url, questionText) ->
    @client.incr 'questionId:' + url, (error, questionNumber) =>
      console.log 'questionNumber' ,questionNumber
      @client.rpush 'questionsForUrl:' + url, questionNumber
      @client.hset 'question:' + questionNumber, 'text', questionText

  vote: (questionNumber, condition) ->
    voteModifier = -1 if condition == 'down'
    voteModifier = 1 if condition == 'up'
    @client.hincrby 'question:' + questionNumber, 'votes', voteModifier

  flag: (questionNumber) ->
    @client.hincrby 'question:' + questionNumber, 'flags', 1

  getQuestions: (url) ->
    questionsPromise = new Promise (resolve) ->
      @client.lrange 'questionsForUrl:' + url, 0, -1, (error, questionArray) =>
        resolve questionArray

    # questionsPromise.then (questionArray) =>
    #   _.map questionArray, (question) =>
    #     @client.hgetall 'question:' + questionNumber


    #     for questionNumber in questionArray
    #       multi.hgetall 'question:' + questionNumber
    #     multi.exec (error, questions) =>
    #       resolve questions
    # questionsPromise.then (questions) ->
    #   console.log questions



module.exports = OORecordsORM
