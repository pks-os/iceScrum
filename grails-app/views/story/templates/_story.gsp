%{--
- Copyright (c) 2015 Kagilum.
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

<script type="text/ng-template" id="story.html">
<div ellipsis
     fast-tooltip
     style="{{ (story.feature ? story.feature.color : '#f9f157') | createGradientBackground }}"
     class="postit {{ ((story.feature ? story.feature.color : '#f9f157') | contrastColor) + ' ' + (story.type | storyType) }}">
    <div class="head">
        <a href
           class="follow"
           uib-tooltip="{{ story.followers_count }} ${message(code: 'todo.is.ui.followers')}" %{-- Cannot use fast-tooltip-el, see comments in the directive --}%
           ng-click="follow(story)">
            <i class="fa" ng-class="story.followed ? 'fa-star' : 'fa-star-o'"></i>
        </a>
        <span class="id">{{ ::story.uid }}</span>
        <span class="value editable"
              fast-tooltip-el="${message(code: 'is.story.value')}"
              ng-click="showEditValueModal(story)"
              ng-if="story.value">
            {{ story.value }} <i class="fa fa-line-chart"></i>
        </span>
        <span class="estimation editable"
              fast-tooltip-el="${message(code: 'is.story.effort')}"
              ng-if="story.state > 1"
              ng-click="showEditEffortModal(story)">
            {{ story.effort != undefined ? story.effort : '?' }} <i class="fa fa-dollar"></i>
        </span>
    </div>
    <div class="content" as-sortable-item-handle-if="sortableStory">
        <h3 class="title ellipsis-el"
            ng-model="story.name"
            ng-bind-html="story.name | sanitize"></h3>
        <div class="description ellipsis-el"
             ng-model="story.description"
             ng-bind-html="story.description | sanitize"></div>
    </div>
    <div class="footer">
        <div class="tags">
            <a ng-repeat="tag in story.tags" ng-click="setTagContext(tag)" href><span class="tag">{{ tag }}</span></a>
        </div>
        <div class="actions">
            <span story-menu class="action"></span>
            <span class="action" ng-class="{'active':story.attachments.length}">
                <a href="#/{{ ::viewName }}/{{ ::story.id }}"
                   fast-tooltip-el="${message(code:'todo.is.ui.backlogelement.attachments')}">
                    <i class="fa fa-paperclip"></i>
                    <span class="badge">{{ story.attachments.length || '' }}</span>
                </a>
            </span>
            <span class="action" ng-class="{'active':story.comments_count}">
                <a href="#/{{ ::viewName }}/{{ ::story.id }}/comments"
                   fast-tooltip-el="${message(code:'todo.is.ui.comments')}">
                    <i class="fa" ng-class="story.comments_count ? 'fa-comment' : 'fa-comment-o'"></i>
                    <span class="badge">{{ story.comments_count  || '' }}</span>
                </a>
            </span>
            <span class="action" ng-class="{'active':story.tasks_count}">
                <a href="#/{{ ::viewName }}/{{ ::story.id }}/tasks"
                   fast-tooltip-el="${message(code:'todo.is.ui.tasks')}">
                    <i class="fa fa-tasks"></i>
                    <span class="badge">{{ story.tasks_count || '' }}</span>
                </a>
            </span>
            <span class="action" ng-class="{'active':story.acceptanceTests_count}">
                <a href="#/{{ ::viewName }}/{{ ::story.id }}/tests"
                   fast-tooltip-el="${message(code:'todo.is.ui.acceptanceTests')}">
                    <i class="fa" ng-class="story.acceptanceTests_count ? 'fa-check-square' : 'fa-check-square-o'"></i>
                    <span class="badge">{{ story.acceptanceTests_count  || '' }}</span>
                </a>
            </span>
        </div>
    </div>
    <div ng-if="tasksProgress(story)" class="progress">
        <span class="status">{{ story.countDoneTasks + '/' + story.tasks_count }}</span>
        <div class="progress-bar"
             ng-class="'bg-'+(story.testState | acceptanceTestColor)"
             style="width: {{ story.countDoneTasks | percentProgress:story.tasks_count }}%">
        </div>
    </div>
    <div class="state"
         ng-class="{'hover-progress':tasksProgress(story)}">{{ story.state | i18n:'StoryStates' }}
    </div>
</div>
</script>