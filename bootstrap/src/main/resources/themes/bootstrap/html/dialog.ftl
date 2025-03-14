  <div class="modal fade" id="${tag.id}" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog [#if tag.cssClass??] ${tag.cssClass}[#else] modal-lg[/#if]"" role="document">
      <div class="modal-content">
        <div class="modal-header" style="padding: 0.5rem 1rem;">
          <h5 class="modal-title">${tag.title!'缺少标题'}</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body" style="padding-top: 0px;">
         [#if tag.href??]
           [@b.div id='${tag.id}Body' style="width:100%" /]
         [#else]
           [@b.div id='${tag.id}Body' href=tag.href style="width:100%" /]
         [/#if]
        </div>
      </div>
    </div>
  </div>
  <script>
    $(function(){
      $("#${tag.id}").on("show.bs.modal",function(e){
        var url = $(e.relatedTarget).attr("href");
        $("#${tag.id}Body").load(url);
      });
    });
  </script>
