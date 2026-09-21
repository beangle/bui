[#if tag.id??]
<div id="${tag.id}" [#if tag.parameters['slash']??]style="position: fixed;margin: 0px 0px 0px 30%;z-index:999;"[/#if]>
[#if tag.hasMessages]
  <div class="alert alert-info alert-dismissible compact">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    [#list tag.actionMessages as message]
    <span>${message!}</span>[#if message_has_next]<br/>[/#if]
    [/#list]
  </div>
[/#if]
[#if tag.hasErrors]
  <div class="alert alert-danger alert-dismissible compact">
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    [#list tag.actionErrors as message]
    <span>${message!}</span>[#if message_has_next]<br/>[/#if]
    [/#list]
  </div>
[/#if]
</div>
[#if tag.parameters['slash']?? && !tag.hasErrors]
<script>
  setTimeout(function(){jQuery('#${tag.id}').fadeOut();},${tag.parameters['slash']}*1000);
</script>
[/#if]
[/#if]
