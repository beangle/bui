[#assign navClass=(tag.cssClass!"")/]
<ul class="${navClass}[#if navClass?contains('nav-tabs') && !navClass?contains('nav-tabs-compact')] nav-tabs-compact[/#if]" [#if tag.id??]id="${tag.id}"[/#if] ${tag.parameterString!}>
${tag.body!}
</ul>
