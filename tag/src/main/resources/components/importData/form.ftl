[#ftl/]
[@b.head/]
[@b.toolbar title=Parameters["display"]!("数据导入")]
    bar.addItem("模板下载","downloadTemplate()","action-download");
[/@]
[@b.messages/]
<br/>
[@b.form action="!importData" theme="list" enctype="multipart/form-data"]
    [@b.field label="文件目录"]
    <input type="file" name="importFile" id="importFile" accept=".xlsx"/>
    [/@]
    [#-- importModes 由 ImportSupport.importForm 放入，格式为 key:标题,key:标题 --]
    [#if importModes??]
    [@b.radios label="导入方式" name="importMode" value=(Parameters["importMode"])!"InsertUpdate" items=importModes comment="覆盖更新会修改已有数据；新导入只接受不存在的数据"/]
    [/#if]
    [@b.formfoot]
      [@b.reset/]
      [@b.submit value="提交" onsubmit="validateExtendName"/]
      [#list Parameters?keys as key]
        [#if key != 'method' && key != 'importMode']<input type="hidden" name="${key}" value="${Parameters[key]}" />[/#if]
      [/#list]
    [/@]
[/@]
 [@b.form name="downloadForm" action="!downloadTemplate" target="_blank"]
   [#list Parameters?keys as key]
     [#if key!='method']<input type="hidden" name="${key}" value="${Parameters[key]}" />[/#if]
   [/#list]
 [/@]
<script type="text/javascript">
    function downloadTemplate(){
        bg.form.submit(document.downloadForm);
    }
    function validateExtendName(form){
        var value = form.importFile.value;
        if(value == ""){
          alert("请选择文件");
          return false;
        }
        var lower = value.toLowerCase();
        if(!lower.endsWith(".xlsx")){
            alert("只能接受以xlsx结尾的电子表格");
            return false;
        }
        return true;
    }
</script>
[@b.foot/]
