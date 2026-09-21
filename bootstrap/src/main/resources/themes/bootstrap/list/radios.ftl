[#ftl]
<li>[#if tag.label??]<label class="title"><em class="required">*</em>${tag.label}:</label>[/#if]
<div class="btn-group" role="group" style="height: 1.5625rem;">
[#list tag.radios as radio]
    <input type="radio" class="btn-check" name="${tag.name}" id="${radio.id}" value="${radio.value}" ${tag.parameterString} [#if (tag.value!"")== radio.value]checked[/#if]>
    <label style="font-size:0.8125rem !important;padding:2px 8px 0px 8px;" class="btn btn-outline-secondary btn-sm [#if (tag.value!"")== radio.value]active[/#if]" for="${radio.id}">${radio.title!}</label>
[/#list]
</div>
<span id="${tag.id}" style="display:none"></span>
[#if tag.comment??]<label class="comment text-muted">${tag.comment}</label>[/#if]
</li>
