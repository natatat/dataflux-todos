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
        # [?] How does the TodoListStore listen to the TodoItemActions?
        # [?] can this be an array [TodoListActions, TodoItemActions?]
        # & onAddItem() a function here (instead of having to call loadAll in TodoInputController)

        init: ->
            @_todos = TodoItemStore._items

        # [?] these are on...() automatically triggered by js data?
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
    controller: ($scope, TodoListStore, TodoItemActions) ->
        TodoListStore.$listen($scope, (event, id) ->
            $scope.todos = TodoListStore._todos
        )

        $scope.removeTodoItem = (id) ->
          TodoItemActions.removeItem(id)
