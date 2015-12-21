#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

angular   = require 'angular'
templates = require '../../templates'
{EVENT}   = require '../../../constants'
_         = require '../../../underscore'

############################################################################################################

### ex: TodoList flow
1. TodoListController listens to TodoListStore and updates its `$scope.todos` when anything changes
2. TodoListController listens to TodoItemStore fires TodoList's loadAll action when todos are added/removed
3. Controller fires removeItem/doItem actions based on user events

############################################################################################################

todo = angular.module('todo')

todo.factory 'TodoListStore', (Todo, TodoItemStore, TodoListActions, ReadOnlyView, reflux) ->
    reflux.createStore

        listenables: TodoListActions

        onLoadAll: ->
            @_todos = TodoItemStore._items
            @trigger(EVENT.CHANGE)


todo.factory 'TodoListActions', (reflux) ->
    reflux.createActions ['loadAll']


todo.directive 'todoList', () ->
    restrict: 'E'
    scope: {}
    template: templates['todo-list']
    controllerAs: 'controller'
    controller: ($scope, TodoListStore, TodoListActions, TodoItemStore, TodoItemActions) ->
        TodoItemStore.$listen($scope, (event, id) ->
            TodoListActions.loadAll() if event == 'add' || event == 'remove' # (2)
        )

        TodoListStore.$listen($scope, (event, id) ->
            $scope.todos = TodoListStore._todos  # (1)
        )

        $scope.removeTodoItem = (id) -> # (3)
            TodoItemActions.removeItem(id)

        $scope.makeDone = (todo) ->
            TodoItemActions.doItem(todo)
