#
# Copyright (C) 2015 by Looker Data Services, Inc.
# All rights reserved.
#

ReadOnlyView = require '../read_only_view'
_ = require '../underscore'

############################################################################################################

PUBLIC_FIELDS = ['id', 'description', 'done']

############################################################################################################

module.exports =
    name: 'todo'
    methods:
        toJSON: ->
            return _.pick this, 'id', 'description', 'done'
        toReadOnlyView: ->
            return new ReadOnlyView this, PUBLIC_FIELDS
