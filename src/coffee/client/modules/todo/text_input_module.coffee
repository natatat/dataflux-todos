#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

angular   = require 'angular'
templates = require '../../templates'
{EVENT}   = require '../../../constants'
_         = require '../../../underscore'

############################################################################################################

### ex: TextInput flow
1. User types in the input, `$scope.setValue(value)` is called with ngChange, which fires TextInput's setValue action
2. `onSetValue()` runs and updates the TextInputStore's value
3. TextInputStore sends a notification that something has changed
4. TextInputController listens to TextInputStore's notifications & updates it's $scope with the new TextInputStore value

############################################################################################################

todo = angular.module('todo')

todo.factory 'TextInputActions', (reflux) ->
    reflux.createActions ['clearValue', 'setValue']

todo.factory 'TextInputStore', (reflux, TextInputActions) ->
    reflux.createStore

        listenables: TextInputActions

        init: ->
            @_value = ""

        getValue: ->
            return @_value

        onSetValue: (value) ->
            @_value = value # (2)
            @trigger(EVENT.CHANGE) # (3)

        onClearValue: ->
            @_value = ""
            @trigger(EVENT.CHANGE)

todo.directive 'textInput', () ->
    restrict: 'E'
    scope: {}
    template: templates['text-input']
    controllerAs: 'controller'
    controller: ($scope, TextInputActions, TextInputStore) ->
        TextInputStore.$listen($scope, (event, id) ->
            $scope.value = TextInputStore.getValue() # (4)
        )

        $scope.setValue = (value) ->
            TextInputActions.setValue(value) # (1)
