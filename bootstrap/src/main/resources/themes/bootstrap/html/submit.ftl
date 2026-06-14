[#ftl]
<input type="submit" id="${tag.id}" [#if tag.cssClass??]class="${tag.cssClass}"[/#if] value="${tag.value!'Submit'}" ${tag.parameterString}/>
<script>
  beangle.ready(function(){
    jQuery('#${tag.id}').on('click', function (e) {
      e.preventDefault();
      bg.form.submit('${tag.formId}',[#if tag.action??]'${tag.action}'[#else]null[/#if],[#if tag.target??]'${tag.target}'[#else]null[/#if],[#if tag.onsubmit??]${tag.onsubmit}[#else]null[/#if]);
      return false;
    });
  });
</script>

