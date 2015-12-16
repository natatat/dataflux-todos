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
            return if event != 'change'
            TodoListActions.loadAll()
        )

        TodoListStore.$listen($scope, (event, id) ->
            $scope.todos = TodoListStore._todos
        )

        $scope.removeTodoItem = (id) ->
          TodoItemActions.removeItem(id)

# TODOS:
# - think about the flow of data (based on that architecture document

# [?]s
# the toReadOnlyView flow...
# a) #4, b) #7

# working on fleshing out my dataflux todoApp, cleaning up my stores, making the text input it's own store
#
# next steps - incorporating jsData with localstorage
# blockers: grunt watch isn't working

# [?] How does the TodoListStore listen to the TodoItemActions? can this be an array [TodoListActions, TodoItemActions]?
# like, if on addTodoItem, we want to TodoListActions.loadAll() again (instead of having to call loadAll in TodoItemStore?)

# [?] why @_items "private"? a: should never be accessed directly
