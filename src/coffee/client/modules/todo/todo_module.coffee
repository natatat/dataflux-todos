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

todo.factory 'TodoItemStore', (Todo, TodoItemActions, TodoListActions, reflux) ->
    reflux.createStore

        listenables: TodoItemActions

        init: ->
            @_items = [] # [?] why "private"?

        getAll: ->
            return @_items[..]

        onAddItem: (todoDescription) ->
            todo = {
                id: _.uniqueId 'todo-'
                description: todoDescription
                done: false
            }
            @_items.unshift(todo)

            @trigger(EVENT.ADD, todo.id)
            @trigger(EVENT.CHANGE)

            TodoListActions.loadAll() # [?] kosher to trigger these actions here?

        onRemoveItem: (id) ->
            @_items = _.filter @_items, (item) -> item.id isnt id

            @trigger(EVENT.REMOVE, todo.id)
            @trigger(EVENT.CHANGE)

            TodoListActions.loadAll()


todo.factory 'TodoItemActions', (reflux) ->
    reflux.createActions ['addItem', 'removeItem']


todo.directive 'todoInput', () ->
    restrict: 'E'
    scope: {}
    template: templates['todo-input']
    controllerAs: 'controller'
    controller: ($scope, TodoItemStore, TodoItemActions) ->
        TodoItemStore.$listen($scope, (event, id) ->
            # [?] is this the right place for this? link function?
             $scope.todo = '' if event == 'add'
        )

        $scope.addTodoItem = (todo) ->
            TodoItemActions.addItem(todo)
