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

todo.factory 'TodoItemStore', (Todo, TodoItemActions, TodoListActions, ReadOnlyView, reflux) ->
    reflux.createStore

        listenables: TodoItemActions

        init: ->
            @_items = []
            # should not be mutable. only changes through listening to an action

        # getAll: ->
        #     console.log(@_items[..])
        #     console.log('huh', @_items)
            # @_items = ReadOnlyView.convertObject @_items[..]
            # return @_items
            # toReadOnlyView(), trying to two way bind is no bueno. should throw an error when tries to "set"

        onAddItem: (todoDescription) ->
            todo = {
                id: _.uniqueId 'todo-'
                description: todoDescription
                done: false
            }
            @_items.unshift(ReadOnlyView.convertObject(todo)) # [?] happen to this object, or the @_items array?
            # setaction(fieldname, action to fire)

            @trigger(EVENT.ADD, todo.id)
            @trigger(EVENT.CHANGE)

        onRemoveItem: (id) ->
            @_items = _.filter @_items, (item) -> item.id isnt id

            @trigger(EVENT.REMOVE, todo.id)
            @trigger(EVENT.CHANGE)


todo.factory 'TodoItemActions', (reflux) ->
    reflux.createActions ['addItem', 'removeItem']


todo.directive 'todoInput', () ->
    restrict: 'E'
    scope: {}
    template: templates['todo-input']
    controllerAs: 'controller'
    controller: ($scope, TodoItemStore, TodoItemActions) ->
        TodoItemStore.$listen($scope, (event, id) ->
            # TODO: make this it's own store
             $scope.todo = '' if event == 'add'
        )

        $scope.addTodoItem = (todo) ->
            TodoItemActions.addItem(todo)
