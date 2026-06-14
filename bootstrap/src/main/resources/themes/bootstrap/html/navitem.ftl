[#ftl]
<li class="nav-item" id="${tag.id}">
[#if tag.href??]
 [#if tag.onclick??]
   [#assign onclick=tag.onclick]
 [#else]
   [#if tag.target??]
     [#assign onclick="jQuery(this).parent().siblings().each(function (i,li){jQuery(li).children('a').removeClass('active')});jQuery(this).addClass('active');return bg.Go(this,'${tag.target}')"]
   [#else]
     [#assign onclick="return bg.Go(this,null)"]
   [/#if]
 [/#if]
<a href="${tag.href}" class="nav-link [#if tag.active]active[/#if]" ${tag.parameterString}>${tag.body!}</a>
[#if onclick??]
<script>
  beangle.ready(function(){
    jQuery('#${tag.id} .nav-link').on('click', function (e) {
      ${onclick}
    });
  });
</script>
[/#if]
[#else]
  ${tag.body!}
[/#if]
</li>
