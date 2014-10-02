<%@ page import="org.icescrum.core.utils.BundleUtils" %>
%{--
- Copyright (c) 2014 Kagilum.
-
- This file is part of iceScrum.
-
- iceScrum is free software: you can redistribute it and/or modify
- it under the terms of the GNU Affero General Public License as published by
- the Free Software Foundation, either version 3 of the License.
-
- iceScrum is distributed in the hope that it will be useful,
- but WITHOUT ANY WARRANTY; without even the implied warranty of
- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- GNU General Public License for more details.
-
- You should have received a copy of the GNU Affero General Public License
- along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
-
- Authors:
-
- Vincent Barrier (vbarrier@kagilum.com)
- Nicolas Noullet (nnoullet@kagilum.com)
--}%
<script type="text/ng-template" id="story.details.html">
<div class="panel panel-default"
     flow-drop
     flow-files-submitted="attachmentQuery($flow, story)"
     flow-drop-enabled="authorizedStory('upload',story)"
     flow-drag-enter="class='panel panel-default drop-enabled'"
     flow-drag-leave="class='panel panel-default'"
     flow-init
     ng-class="authorizedStory('upload',story) && class">
    <div id="story-header"
         class="panel-heading"
         fixed="#right"
         fixed-offset-top="1"
         fixed-offset-width="-2">
        <h3 class="panel-title row">
            <div class="the-title">
                <a href
                   tooltip="{{ story.followers_count }} ${message(code: 'todo.is.ui.followers')}"
                   tooltip-append-to-body="true"
                   ng-click="follow(story)"
                   ng-switch="story.followed"><i class="fa fa-star-o" ng-switch-default></i><i class="fa fa-star" ng-switch-when="true"></i></a>
                <span>{{ story.name }}</span> <small ng-show="story.origin">${message(code: 'is.story.origin')}: {{ story.origin }}</small>
            </div>
            <div class="the-id">
                <div class="pull-right">
                    <span tooltip="${message(code: 'is.story.creator')} : {{ story.creator | userFullName }}"
                          tooltip-append-to-body="true">
                        <img ng-src="{{ story.creator | userAvatar }}" alt="{{ story.creator | userFullName }}"
                             height="21px"/>
                    </span>
                    <span class="label label-default"
                          tooltip="${message(code: 'is.backlogelement.id')}"
                          tooltip-append-to-body="true">{{ story.uid }}</span>

                    <a ng-if="previous"
                       class="btn btn-xs btn-default"
                       role="button"
                       tabindex="0"
                       href="#sandbox/{{ previous.id }}"><i class="fa fa-caret-left" title="${message(code:'is.ui.backlogelement.toolbar.previous')}"></i></a>
                    <a ng-if="next"
                       class="btn btn-xs btn-default"
                       role="button"
                       tabindex="0"
                       href="#sandbox/{{ next.id }}"><i class="fa fa-caret-right" title="${message(code:'is.ui.backlogelement.toolbar.next')}"></i></a>
                </div>
            </div>
        </h3>
        <div class="actions">
            <div class="actions-left">
                <div class="btn-group"
                     ng-if="authorizedStory('menu', story)"
                     tooltip="${message(code: 'todo.is.ui.actions')}"
                     tooltip-append-to-body="true">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                        <span class="fa fa-cog"></span> <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu"
                        ng-include="'story.menu.html'"></ul>
                </div>
                <button type="button"
                        popover-title="${message(code:'is.permalink')}"
                        popover="{{ serverUrl + '/TODOPKEY-' + story.uid }}"
                        popover-append-to-body="true"
                        popover-placement="left"
                        class="btn btn-default">
                    <span class="fa fa-link"></span>
                </button>
                <button class="btn btn-default"
                        type="button"
                        ng-click="like(story)"
                        ng-switch="story.liked"
                        role="button"
                        tabindex="0"
                        tooltip="{{ story.likers_count }} ${message(code: 'todo.is.ui.likers')}"
                        tooltip-append-to-body="true">
                    <i class="fa fa-thumbs-o-up" ng-switch-default></i>
                    <i class="fa fa-thumbs-up" ng-switch-when="true"></i>
                    <span class="badge" ng-show="story.likers_count">{{ story.likers_count }}</span>
                </button>
                <button class="btn btn-primary"
                        type="button"
                        tooltip="${message(code:'todo.is.ui.editable.enable')}"
                        ng-if="authorizedStory('update', story) && !getEditableMode(story)"
                        ng-click="enableEditableStoryMode()"><span class="fa fa-pencil"></span></button>
                <button class="btn btn-default"
                        type="button"
                        tooltip="${message(code:'todo.is.ui.editable.disable')}"
                        ng-if="getEditableStoryMode(story)"
                        ng-click="confirm({ message: '${message(code: 'todo.is.ui.dirty.confirm')}', callback: disableEditableStoryMode, condition: isDirty() })"><span class="fa fa-pencil-square-o"></span></button>
            </div>
            <div class="actions-right">
                <div class="btn-group pull-right">
                    <button name="activities"
                            class="btn btn-default"
                            type="button"
                            ng-click="setTabSelected('activities')"
                            tooltip="${message(code:'todo.is.story.lastActivity')}"
                            tooltip-append-to-body="true">
                        <span class="fa fa-clock-o"></span>
                    </button>
                    <button name="attachments"
                            class="btn btn-default"
                            type="button"
                            ng-click="setTabSelected('attachments')"
                            tooltip="{{ story.attachments.length }} ${message(code:'todo.is.backlogelement.attachments')}"
                            tooltip-append-to-body="true">
                        <span class="fa fa-paperclip"></span>
                        <span class="badge" ng-show="story.attachments_count">{{ story.attachments_count }}</span>
                    </button>
                    <button name="comments"
                            class="btn btn-default"
                            type="button"
                            ng-click="setTabSelected('comments')"
                            tooltip="{{ story.comments.length }} ${message(code:'todo.is.story.comments')}"
                            tooltip-append-to-body="true"
                            ng-switch="story.comments_count">
                        <span class="fa fa-comment-o" ng-switch-when="0"></span>
                        <span class="fa fa-comment" ng-switch-default></span>
                        <span class="badge" ng-show="story.comments_count">{{ story.comments_count }}</span>
                    </button>
                    <button name="tasks"
                            class="btn btn-default"
                            type="button"
                            ng-click="setTabSelected('tasks')"
                            tooltip="{{ story.tasks_count }} ${message(code:'todo.is.story.tasks')}"
                            tooltip-append-to-body="true">
                        <span class="fa fa-tasks"></span>
                        <span class="badge" ng-show="story.tasks_count">{{ story.tasks_count }}</span>
                    </button>
                    <button name="tests"
                            class="btn btn-default"
                            type="button"
                            ng-click="setTabSelected('tests')"
                            tooltip="{{ story.acceptanceTests_count }} ${message(code:'todo.is.acceptanceTests')}"
                            tooltip-append-to-body="true"
                            tooltip-placement="left"
                            ng-switch="story.acceptanceTests_count">
                        <span class="fa fa-check-square-o" ng-switch-when="0"></span>
                        <span class="fa fa-check-square" ng-switch-default></span>
                        <span class="badge" ng-if="story.acceptanceTests_count">{{ story.acceptanceTests_count }}</span>
                    </button>
                </div>
            </div>
        </div>
        <div class="progress-container">
            <div class="progress">
                <div ng-repeat="progressState in progressStates"
                     class="progress-bar progress-bar-{{ progressState.code }}"
                     tooltip-placement="left"
                     tooltip-append-to-body="true"
                     tooltip="{{ progressState.name }}" style="width:{{ progressState.width }}%">
                    {{ progressState.days }}
                </div>
            </div>
        </div>
    </div>

    <div id="right-story-container"
         class="panel-body">
        <form ng-submit="update(editableStory)"
              name='formHolder.storyForm'
              ng-class="{'form-disabled': !getEditableStoryMode(story)}"
              show-validation
              novalidate>
            <div class="clearfix no-padding">
                <div class="form-half">
                    <label for="name">${message(code:'is.story.name')}</label>
                    <input required
                           ng-maxlength="100"
                           ng-disabled="!getEditableStoryMode(story)"
                           name="name"
                           ng-model="editableStory.name"
                           type="text"
                           class="form-control">
                </div>
                <div class="form-half" ng-switch="getEditableStoryMode(story) || !editableStory.feature">
                    <label for="feature">${message(code:'is.feature')}</label>
                    <div ng-switch-when="true"
                         ng-class="{'input-group':editableStory.feature.id, 'select2-border':editableStory.feature.id}">
                        <input type="hidden"
                               ng-disabled="!getEditableStoryMode(story)"
                               class="form-control"
                               value="{{ editableStory.feature.id ? editableStory.feature : '' }}"
                               name="feature"
                               ng-model="editableStory.feature"
                               ui-select2="selectFeatureOptions"
                               data-placeholder="${message(code: 'is.ui.story.nofeature')}"/>
                        <span class="input-group-btn" ng-show="editableStory.feature.id">
                            <a href="#feature/{{ editableStory.feature.id }}"
                               title="{{ editableStory.feature.name }}"
                               class="btn btn-default">
                                <i class="fa fa-external-link"></i>
                            </a>
                        </span>
                    </div>
                    <a ng-switch-default href="#feature/{{ editableStory.feature.id }}">
                        <input type="text"
                               class="form-control"
                               value="{{ editableStory.feature.name }}"
                               disabled="disabled"/>
                    </a>
                </div>
            </div>
            <div class="clearfix no-padding">
                <div class="form-group"
                     ng-class="{ 'form-half' : editableStory.type == 2 }">
                    <label for="type">${message(code:'is.story.type')}</label>
                    <select class="form-control"
                            ng-disabled="!getEditableStoryMode(story)"
                            name="type"
                            ng-model="editableStory.type"
                            ui-select2>
                        <is:options values="${is.internationalizeValues(map: BundleUtils.storyTypes)}" />
                    </select>
                </div>
                <div class="form-half"
                     ng-show="editableStory.type == 2">
                    <label for="affectVersion">${message(code:'is.story.affectVersion')}</label>
                    <input class="form-control"
                           ng-disabled="!getEditableStoryMode(story)"
                           type="hidden"
                           value="{{ editableStory.affectVersion  }}"
                           name="affectVersion"
                           ng-model="editableStory.affectVersion"
                           ui-select2="selectAffectionVersionOptions"
                           data-placeholder="${message(code:'is.ui.story.noaffectversion')}"/>
                </div>
            </div>
            <div class="form-group">
                <label for="dependsOn">${message(code:'is.story.dependsOn')}</label>
                <div ng-class="{'input-group':editableStory.dependsOn.id}">
                    <input  type="hidden"
                            ng-disabled="!getEditableStoryMode(story)"
                            style="width:100%;"
                            class="form-control"
                            value="{{ editableStory.dependsOn.id ? editableStory.dependsOn : '' }}"
                            name="dependsOn"
                            ng-model="editableStory.dependsOn"
                            ui-select2="selectDependsOnOptions"
                            data-placeholder="${message(code: 'is.ui.story.nodependence')}"/>
                    <span class="input-group-btn" ng-show="editableStory.dependsOn.id">
                        <a href="#story/{{ editableStory.dependsOn.id }}"
                           title="{{ editableStory.dependsOn.name }}"
                           class="btn btn-default">
                            <i class="fa fa-external-link"></i>
                        </a>
                    </span>
                </div>
                <div class="clearfix" style="margin-top: 15px;" ng-if="editableStory.dependences.length">
                    <strong>${message(code:'is.story.dependences')} :</strong>
                    <a class="scrum-link" title="{{ dependence.name }}" ng-repeat="dependence in editableStory.dependences">{{ dependence.name }}</a>
                </div>
            </div>
            <div class="form-group">
                <label for="description">${message(code:'is.backlogelement.description')}</label>
                <textarea class="form-control"
                          ng-maxlength="3000"
                          name="description"
                          ng-model="editableStory.description"
                          ng-show="showDescriptionTextarea"
                          ng-blur="blurDescription('${is.generateStoryTemplate(newLine: '\\n')}')"
                          at="atOptions"
                          focus-me="{{ showDescriptionTextarea }}"
                          placeholder="${message(code: 'is.ui.backlogelement.nodescription')}"></textarea>
                <div class="atwho-preview form-control-static"
                     ng-disabled="!getEditableStoryMode(story)"
                     ng-show="!showDescriptionTextarea"
                     ng-click="clickDescriptionPreview($event, '${is.generateStoryTemplate(newLine: '\\n')}')"
                     ng-focus="focusDescriptionPreview($event)"
                     ng-mousedown="descriptionPreviewMouseDown = true"
                     ng-mouseup="descriptionPreviewMouseDown = false"
                     ng-class="{'placeholder': !editableStory.description}"
                     tabindex="0"
                     ng-bind-html="(editableStory.description ? (editableStory | descriptionHtml) : '${message(code: 'is.ui.backlogelement.nodescription')}') | sanitize"></div>
            </div>
            <div class="form-group">
                <label for="tags">${message(code:'is.backlogelement.tags')}</label>
                <input type="hidden"
                       ng-disabled="!getEditableStoryMode(story)"
                       class="form-control"
                       value="{{ editableStory.tags.join(',') }}"
                       name="tags"
                       ng-model="editableStory.tags"
                       data-placeholder="${message(code:'is.ui.backlogelement.notags')}"
                       ui-select2="selectTagsOptions"/>
            </div>
            <div class="form-group">
                <label for="notes">${message(code:'is.backlogelement.notes')}</label>
                <textarea is-markitup
                          ng-maxlength="5000"
                          class="form-control"
                          name="notes"
                          ng-model="editableStory.notes"
                          is-model-html="editableStory.notes_html"
                          ng-show="showNotesTextarea"
                          ng-blur="showNotesTextarea = false"
                          placeholder="${message(code: 'is.ui.backlogelement.nonotes')}"></textarea>
                <div class="markitup-preview"
                     ng-disabled="!getEditableStoryMode(story)"
                     ng-show="!showNotesTextarea"
                     ng-click="showNotesTextarea = getEditableStoryMode(story)"
                     ng-focus="showNotesTextarea = getEditableStoryMode(story)"
                     ng-class="{'placeholder': !editableStory.notes_html}"
                     tabindex="0"
                     ng-bind-html="(editableStory.notes_html ? editableStory.notes_html : '<p>${message(code: 'is.ui.backlogelement.nonotes')}</p>') | sanitize"></div>
            </div>
            <div class="form-group">
                <label>${message(code:'is.backlogelement.attachment')}</label>
                <div class="form-control-static">
                    <div class="drop-zone">
                        <h2>${message(code:'todo.is.ui.drop.here')}</h2>
                    </div>
                    <table class="table table-striped attachments">
                        <tbody>
                            <tr ng-repeat="attachment in story.attachments | orderBy:'dateCreated'">
                                <td>
                                    <div class="col-sm-8">
                                        <div class="filename" title="{{ attachment.filename }}"><i class="fa fa-{{ attachment.ext | fileicon }}"></i> {{ attachment.filename }}</div>
                                        <div><small>{{ attachment.length | filesize }}</small></div>
                                    </div>
                                    <div class="col-sm-4 text-right">
                                        <div class="btn-group">
                                            <button type="button" class="btn btn-default btn-xs"><i class="fa fa-download"></i></button>
                                            <button ng-click="" type="button" class="btn btn-danger btn-xs"><i class="fa fa-close"></i></button>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr ng-repeat="file in $flow.files">
                                <td>
                                    <div class="col-sm-8">
                                        <div class="filename" title="{{file.name}}"><i class="fa fa-{{ file.name | fileicon }}"></i> {{ file.name }}</div>
                                        <div><small>{{ file.size | filesize }}</small></div>
                                    </div>
                                    <div class="col-sm-4 text-right">
                                        <div class="progress ng-hide" ng-show="!file.paused && file.isUploading()">
                                            <div class="progress-bar" role="progressbar" ng-style="{width: (file.sizeUploaded() / file.size * 100) + '%'}">
                                                {{file.sizeUploaded() / file.size * 100 | number:0}}%
                                            </div>
                                        </div>
                                        <div class="btn-group">
                                            <button class="btn btn-xs btn-warning ng-hide" ng-click="file.pause()"  ng-show="!file.paused && file.isUploading()"><i class="fa fa-pause"></i></button>
                                            <button class="btn btn-xs btn-warning ng-hide" ng-click="file.resume()" ng-show="file.paused"><i class="fa fa-play"></i></button>
                                            <button class="btn btn-xs btn-danger"          ng-click="file.cancel()"><i class="fa fa-close"></i></button>
                                            <button class="btn btn-xs btn-info ng-hide"    ng-click="file.retry()"  ng-show="file.error"><i class="fa fa-refresh"></i></button>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>
            <div class="btn-toolbar" ng-if="getEditableStoryMode(story)">
                <button class="btn btn-primary pull-right"
                        ng-class="{ disabled: !isDirty() || formHolder.storyForm.$invalid }"
                        tooltip="${message(code:'todo.is.ui.update')} (RETURN)"
                        tooltip-append-to-body="true"
                        type="submit">
                    ${message(code:'todo.is.ui.update')}
                </button>
                <button class="btn confirmation btn-default pull-right"
                        ng-class="{ disabled: !isDirty() }"
                        tooltip-append-to-body="true"
                        tooltip="${message(code:'is.button.cancel')}"
                        type="button"
                        ng-click="resetStoryForm()">
                    ${message(code:'is.button.cancel')}
                </button>
            </div>
        </form>
    </div>
</div>
<div class="panel panel-default">
    <div class="panel-body">
        <tabset type="{{ tabsType }}">
            <tab select="activities(story); ($state.params.tabId ? setTabSelected('activities') : '');"
                 heading="${message(code: 'is.ui.backlogelement.activity')}"
                 active="tabSelected.activities">
                <table class="table table-striped">
                    <tbody ng-include="'activity.list.html'" ng-init="selected = story"></tbody>
                </table>
            </tab>
            <tab select="comments(story); setTabSelected('comments');"
                 heading="${message(code: 'is.ui.backlogelement.activity.comments')}"
                 active="tabSelected.comments">
                <table class="table">
                    <tbody ng-include="'comment.list.html'" ng-init="selected = story"></tbody>
                </table>
                <table class="table" ng-controller="commentCtrl">
                    <tbody>
                    <tr ng-if="authorizedComment('create')">
                        <td><div ng-include="'comment.editor.html'"></div></td>
                    </tr>
                    </tbody>
                </table>
            </tab>
            <tab select="tasks(story); setTabSelected('tasks');"
                 heading="${message(code: 'is.ui.backlogelement.activity.task')}"
                 active="tabSelected.tasks">
                <table ng-controller="taskCtrl"
                       class="table">
                    <tbody ng-if="authorizedTask('create')"
                           ng-include="'story.task.new.html'"></tbody>
                </table>
                <table class="table">
                    <tbody ng-include="'story.tasks.html'"></tbody>
                </table>
            </tab>
            <tab select="acceptanceTests(story); setTabSelected('tests');"
                 heading="${message(code: 'is.ui.backlogelement.activity.test')}"
                 active="tabSelected.tests">
                <table class="table" ng-controller="acceptanceTestCtrl">
                    <tbody>
                    <tr ng-if="authorizedAcceptanceTest('create', editableAcceptanceTest)">
                        <td><div ng-include="'story.acceptanceTest.editor.html'"></div></td>
                    </tr>
                    </tbody>
                </table>
                <table class="table">
                    <tbody ng-include="'story.acceptanceTests.html'"></tbody>
                </table>
            </tab>
        </tabset>
    </div>
</div>
</script>