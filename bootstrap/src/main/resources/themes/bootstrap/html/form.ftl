[#ftl]
<form id="${tag.id}" name="${tag.name}" [#if tag.cssClass??] class="${tag.cssClass}"[/#if] action="${tag.action}" method="${tag.method}" [#if tag.target??]target="${tag.target}"[/#if] [#if tag.enctype??]enctype="${tag.enctype}"[/#if] ${tag.parameterString}>
[#if Parameters['_params']??]<input name="_params" type="hidden" value="${Parameters['_params']?html}" />[/#if]
${tag.body}
</form>
[#if (tag.validate!"")=="true" ||tag.onsubmit??]
<script>
  beangle.require(["jquery-validity"]);
  beangle.ready(function(){
    document.getElementById('${tag.id}').onsubmit=function(){
      var res=null;
    [#if (tag.validate!"")=="true"]
      jQuery.validity.start();
      ${tag.validity}
      res = jQuery.validity.end().valid;
    [/#if]
      if(false==res) return false;
      [#if tag.onsubmit??]${tag.onsubmit}[/#if]
      return res;
    }
  });
</script>
[/#if]
