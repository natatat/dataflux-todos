#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

angular   = require 'angular'
templates = require '../../templates'
{EVENT}   = require '../../../constants'
_         = require '../../../underscore'

############################################################################################################

### ex: TodoItem flow
1. User clicks the submit button, `$scope.addTodoItem()` fires TodoItems's addTodoItem action
2. `onAddItem()` runs and creates a new ReadOnlyView TodoItem, pushes it into @_items
    (3. Register doItem action to run when the 'done' field of the ReadOnlyView is changed)
4. TodoItemStore sends a notification that something has been added and changed

############################################################################################################

todo = angular.module('todo', ['reflux'])

todo.factory 'TodoItemStore', (ReadOnlyView, reflux, TextInputStore, Todo, TodoItemActions) ->
    reflux.createStore

        listenables: TodoItemActions

        init: ->
            @_items = []

        getAll: ->

        onAddItem: -> # (2)
            todo = new ReadOnlyView({
                id: _.uniqueId 'todo-'
                description: TextInputStore.getValue()
                done: false
            }, ['id', 'description', 'done'])
            @_items.unshift(todo)

            todo.setAction('done', TodoItemActions.doItem) # (3)

            @trigger(EVENT.ADD, todo.id) # (4)
            @trigger(EVENT.CHANGE) # (4)

        onRemoveItem: (id) ->
            for item, index in @_items
                continue unless item.id is id
                @_items.splice index, 1
                break

            @trigger(EVENT.REMOVE, id)
            @trigger(EVENT.CHANGE)

        onDoItem: (todo, field, value, commit) ->
            # todo._actions.done(!todo.done)

            @trigger(EVENT.CHANGE)


todo.factory 'TodoItemActions', (reflux) ->
    reflux.createActions ['addItem', 'doItem', 'removeItem']


todo.directive 'todoForm', () ->
    restrict: 'E'
    scope: {}
    template: templates['todo-form']
    controllerAs: 'controller'
    controller: ($scope, TextInputActions, TodoItemActions) ->
        $scope.addTodoItem = ->
            TodoItemActions.addItem() # (1)
            TextInputActions.clearValue()

