[#ftl]
<button type="submit" id="${tag.id}" class="${tag.cssClass!'btn btn-outline-primary btn-sm'}" ${tag.parameterString}>
<i class="fa fa-search fa-sm"></i> ${tag.value!'Submit'}
</button>
<script>
  beangle.ready(function(){
    jQuery('#${tag.id}').on('click', function (e) {
      e.preventDefault();
      bg.form.submit('${tag.formId}',[#if tag.action??]'${tag.action}'[#else]null[/#if],[#if tag.target??]'${tag.target}'[#else]null[/#if],[#if tag.onsubmit??]${tag.onsubmit}[#else]null[/#if]);
      return false;
    });
  });
</script>
