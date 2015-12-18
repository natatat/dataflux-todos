#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

angular   = require 'angular'
templates = require '../../templates'
{EVENT}   = require '../../../constants'
_         = require '../../../underscore'

############################################################################################################

todo = angular.module('todo', ['reflux'])

todo.factory 'TodoItemStore', (Todo, TodoItemActions, TextInputStore, ReadOnlyView, reflux) ->
    reflux.createStore

        listenables: TodoItemActions

        init: ->
            @_items = []

        # getAll: ->
            # @_items = ReadOnlyView.convertObject @_items[..]
            # return @_items

        onAddItem: ->
            @_todo = new ReadOnlyView({
                id: _.uniqueId 'todo-'
                description: TextInputStore._value
                done: false
            }, ['id', 'description', 'done'])
            @_items.unshift(@_todo)

            @_todo.setAction('done', (todo, field, value, commit) ->
                # field = !value
                # commit(!value)
                # console.log(todo)
                # console.log(field)
                # console.log(value)
                # console.log(commit)
            )

            @trigger(EVENT.ADD, @_todo.id)
            @trigger(EVENT.CHANGE)

        onRemoveItem: (id) ->
            @_items = _.filter @_items, (item) -> item.id isnt id

            @trigger(EVENT.REMOVE, @_todo.id)
            @trigger(EVENT.CHANGE)

        onDoItem: (id) ->
            # item = _.find @_items, (item) -> item.id == id
            # item.done = !item.done

            @trigger(EVENT.CHANGE)


todo.factory 'TodoItemActions', (reflux) ->
    reflux.createActions ['addItem', 'removeItem', 'doItem']


todo.directive 'todoForm', () ->
    restrict: 'E'
    scope: {}
    template: templates['todo-form']
    controllerAs: 'controller'
    controller: ($scope, TodoItemActions, TextInputActions) ->
        $scope.addTodoItem = ->
            TodoItemActions.addItem()
            TextInputActions.clearValue()

