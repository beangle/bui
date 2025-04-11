[#ftl]
<li>[#if tag.label??]<label class="title">[#if (tag.required!"")=="true"]<em class="required">*</em>[/#if]${tag.label}:</label>[/#if]
  <div style="display:inline-block;">
    <div class="custom-file" style="text-align:left;">
      <input type="file" class="custom-file-input" name="${tag.name}" [#if tag.id??]id="${tag.id}"[/#if] title="${tag.label!'File'}" ${tag.parameterString}>
      <label class="custom-file-label" for="${tag.id}">
        ${tag.maxSize?number/1024.0}M以内[#if tag.extensions?length>0],格式为${tag.extensions}的文件[/#if]
      </label>
    </div>
  </div>
  [#if tag.comment??]<span class="comment text-muted">${tag.comment}</span>[/#if]
  <span id="${tag.id}_filesize" class="text-muted"></span>
</li>
<script>
    $(document).ready(function() {
      document.getElementById('${tag.id}').onchange=function(){
        jQuery(this).data('file',event.target.files[0]);
        beangle.displayFileInfo('${tag.id}_filesize',event.target.files[0],${tag.maxSize}*1024);
        if(this.value){
          var fileName = this.value.replaceAll('\\','/');
          this.nextElementSibling.innerHTML=fileName.substring(fileName.lastIndexOf('/')+1);
        }
      }
    });
</script>