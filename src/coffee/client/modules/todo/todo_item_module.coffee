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
2. `onAddItem()` runs and creates a new ReadOnlyView TodoItem, pushes it into @_todos
    (3. Register doItem action to run when the 'done' field of the ReadOnlyView is changed)
4. TodoItemStore sends a notification that something has been added and changed

############################################################################################################

todo = angular.module('todo', ['reflux'])

todo.factory 'TodoItemStore', (ReadOnlyView, reflux, TextInputStore, Todo, TodoItemActions) ->
    reflux.createStore

        listenables: TodoItemActions

        init: ->
            @_todos = []

        get: (id) ->
            for todo in @_todos
                return todo if todo.id is id

        getAll: ->
            return @_todos

        onAddItem: -> # (2)
            todo = new ReadOnlyView({
                id: _.uniqueId 'todo-'
                description: TextInputStore.getValue()
                done: false
            }, ['id', 'description', 'done'])
            @_todos.unshift(todo)

            todo.setAction('done', TodoItemActions.doItem) # (3)

            @trigger(EVENT.ADD, todo.id) # (4)
            @trigger(EVENT.CHANGE) # (4)

        onRemoveItem: (id) ->
            for todo, index in @_todos
                continue unless todo.id is id
                @_todos.splice index, 1
                break

            @trigger(EVENT.REMOVE, id)
            @trigger(EVENT.CHANGE)

        onDoItem: (todo, field, value, commit) ->
            # commit(value)
            # todo._actions.done(!todo.done)

            @trigger(EVENT.CHANGE)


todo.factory 'TodoItemActions', (reflux) ->
    reflux.createActions ['addItem', 'doItem', 'removeItem']


todo.directive 'todoItem', () ->
    restrict: 'E'
    scope:
        id: "=todoId"
    template: templates['todo-item']
    controllerAs: 'controller'
    controller: ($scope, TodoItemStore, TodoItemActions) ->
        TodoItemStore.$listen($scope, (event, id) ->
            todo = TodoItemStore.get($scope.id)
            return unless todo
            $scope.description = todo.description
            $scope.done = todo.done
        )

        # Controller fires removeItem/doItem actions based on user events
        $scope.removeTodoItem = ->
            TodoItemActions.removeItem($scope.id)

        $scope.makeDone = -> # TODO
            TodoItemActions.doItem()


todo.directive 'todoForm', () ->
    restrict: 'E'
    scope: {}
    template: templates['todo-form']
    controllerAs: 'controller'
    controller: ($scope, TextInputActions, TodoItemActions) ->
        $scope.addTodoItem = ->
            TodoItemActions.addItem() # (1)
            TextInputActions.clearValue()

