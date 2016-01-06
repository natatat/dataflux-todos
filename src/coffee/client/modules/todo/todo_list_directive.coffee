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
1. TodoListController listens to TodoListStore and updates its `$scope.todos` when todos are added/removed

############################################################################################################

todo = angular.module('todo')

todo.directive 'todoList', () ->
    restrict: 'E'
    scope: {}
    template: templates['todo-list']
    controllerAs: 'controller'
    controller: ($scope, TodoItemActions, TodoItemStore) ->
        TodoItemStore.$listen($scope, (event, id) ->
            $scope.todos = TodoItemStore.getAll() if event == 'add' || event == 'remove' # (1)
        )
