#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

angular   = require 'angular'
templates = require '../../templates'
{EVENT}   = require '../../../constants'
_         = require '../../../underscore'

############################################################################################################

todo = angular.module('todo')

todo.factory 'TodoListStore', (TodoItemStore, TodoListActions, reflux) ->
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
            TodoListActions.loadAll() if event == 'add' || event == 'remove'
        )

        TodoListStore.$listen($scope, (event, id) ->
            $scope.todos = TodoListStore._todos
        )

        $scope.removeTodoItem = (id) ->
            TodoItemActions.removeItem(id)

        $scope.makeDone = (id) ->
            TodoItemActions.doItem(id)
