<li>[#if tag.label??]<label for="${tag.id}" class="title">[#if (tag.required!"")=="true"]<em class="required">*</em>[/#if]${tag.label}:</label>[/#if]
  <input type="hidden" id="${tag.id}" name="${tag.name}" title="${tag.title!}"/>
  <table border="0">
    <tr>
      <td>
       <canvas id="${tag.id}_canvas" class="esign-canvas"></canvas>
       [#if tag.comment??]<label class="comment text-muted">${tag.comment}</label>[/#if]
      </td>
    </tr>
    <tr>
      <td style="text-align:right;">
       [#if tag.enableLocalFile=="true"]
       <div class="custom-file" style="text-align:left;width:200px;">
         <input type="file" class="custom-file-input" id="validatedCustomFile"  name="sign_local_file" title="签名" onchange="esign_${tag.id}.loadFile(event.target.files[0]);">
         <label class="custom-file-label" for="validatedCustomFile">选择签名图片</label>
       </div>
       [/#if]
       [#if tag.remoteHref??]
       <button onclick="esign_${tag.id}.loadURL('${tag.remoteHref}');return false;" class="btn btn-sm btn-outline-primary" style="margin-top: 11px;height: 37px;display:none;">
         <img src="${tag.remoteHref}" height="20" width="40" onload="displayImageButton(this)"/>&nbsp;默认
       </button>
       [/#if]
       <button id="${tag.id}_clear" class="btn btn-sm btn-outline-primary" style="margin-top: 11px;height: 37px;">清空</button>
      </td>
    </tr>
  </table>
</li>
<style>
.esign-canvas {
  border: 2px solid #ccc;
}
</style>
<script>
  function Esign(canvas,options){
    this.options= options;
    this.canvas=canvas;
    this.width = options.width || 800;
    this.height = options.height || 300;
    this.lineWidth = options.lineWidth || 4;
    this.lineColor = '#000000';
    this.bgColor = '';
    this.isCrop = false; //是否裁剪
    this.isClearBgColor = true;
    this.format = 'image/png';
    this.quality = 1;
    //data
    this.hasDrew = false;
    this.resultImg = '';
    this.points = [];
    this.canvasCtx = null;
    this.startX = 0;
    this.startY = 0;
    this.isDrawing = false;
    this.sratio = 1;

    this.ratio = function() {
      return this.height / this.width
    }
    this.myBg= function () {
      return this.bgColor ? this.bgColor : 'rgba(255, 255, 255, 0)'
    }
    this.stageInfo = function() {
      return this.canvas.getBoundingClientRect()
    }
    this.resizeHandler = function(){
      this.width = this.options.width || 800;
      this.height = this.options.height || 300;
      if(this.width > document.body.clientWidth - 100){
        this.width = document.body.clientWidth - 100;
      }
      if(this.height > document.body.clientHeight){
        this.height = document.body.clientHeight;
      }
      this.canvas.style.width = this.width + "px"
      var realw = parseFloat(window.getComputedStyle(canvas).width);
      this.canvas.style.height = this.ratio() * realw + "px";
      this.canvasCtx = this.canvas.getContext('2d');
      this.sratio = realw / this.width;
      this.canvasCtx.scale(1 * this.sratio, 1 * this.sratio);
    }
    //mounting
    this.mount = function(){
      this.resizeHandler();
      this.canvas.height = this.height;
      this.canvas.width = this.width;
      this.canvas.style.background = this.myBg();
      var t = this;
      document.addEventListener("mouseup", function(){
        t.isDrawing = false;
      });
      window.addEventListener('resize', function(){t.resizeHandler();});
      //for pc
      this.canvas.addEventListener("mousedown",function(e){
        e.preventDefault();
        t.isDrawing = true
        t.hasDrew = true
        t.drawStart({x: e.offsetX,y: e.offsetY })
      });
      this.canvas.addEventListener("mousemove",function (e) {
        e.preventDefault();
        if (t.isDrawing) {
          t.drawMove({x: e.offsetX,y: e.offsetY })
        }
      });
      this.canvas.addEventListener("mouseup",function (e) {
        e.preventDefault();
        t.drawEnd({x: e.offsetX,y: e.offsetY })
        t.isDrawing = false;
      });
      //for mobile
      this.canvas.addEventListener("touchstart",function(e) {
        e.preventDefault();
        e.stopPropagation();
        t.hasDrew = true;
        if (e.touches.length === 1) {
          var loc = {
            x: e.targetTouches[0].clientX - t.canvas.getBoundingClientRect().left,
            y: e.targetTouches[0].clientY - t.canvas.getBoundingClientRect().top
          }
          t.drawStart(loc);
        }
      });
      this.canvas.addEventListener("touchmove",function (e) {
        e.preventDefault();
        e.stopPropagation();
        if (e.touches.length === 1) {
          var loc = {
            x: e.targetTouches[0].clientX - t.canvas.getBoundingClientRect().left,
            y: e.targetTouches[0].clientY - t.canvas.getBoundingClientRect().top
          }
          t.drawMove(loc);
        }
      });
      this.canvas.addEventListener("touchend", function (e) {
        e.preventDefault();
        e.stopPropagation();
        if (e.touches.length === 1) {
          var loc = {
            x: e.targetTouches[0].clientX - t.canvas.getBoundingClientRect().left,
            y: e.targetTouches[0].clientY - t.canvas.getBoundingClientRect().top
          }
          t.drawEnd(loc);
        }
      });
    }
    // 绘制
    this.drawStart = function(loc) {
      this.startX = loc.x;
      this.startY = loc.y;
      this.canvasCtx.beginPath();
      this.canvasCtx.moveTo(this.startX, this.startY);
      this.canvasCtx.lineTo(loc.x, loc.y);
      this.canvasCtx.lineCap = 'round';
      this.canvasCtx.lineJoin = 'round';
      this.canvasCtx.lineWidth = this.lineWidth * this.sratio;
      this.canvasCtx.stroke();
      this.canvasCtx.closePath();
      this.points.push(loc);
    }

    this.drawMove = function (loc) {
      this.canvasCtx.beginPath();
      this.canvasCtx.moveTo(this.startX, this.startY);
      this.canvasCtx.lineTo(loc.x, loc.y);
      this.canvasCtx.strokeStyle = this.lineColor;
      this.canvasCtx.lineWidth = this.lineWidth * this.sratio
      this.canvasCtx.lineCap = 'round';
      this.canvasCtx.lineJoin = 'round';
      this.canvasCtx.stroke();
      this.canvasCtx.closePath();
      this.startY = loc.y;
      this.startX = loc.x;
      this.points.push(loc);
    }
    this.drawEnd = function (loc) {
      this.canvasCtx.beginPath();
      this.canvasCtx.moveTo(this.startX, this.startY);
      this.canvasCtx.lineTo(loc.x, loc.y);
      this.canvasCtx.lineCap = 'round';
      this.canvasCtx.lineJoin = 'round';
      this.canvasCtx.stroke();
      this.canvasCtx.closePath();
      this.points.push(loc);
      this.points.push({x: -1, y: -1});
    }
    this.clear = function () {
      this.canvasCtx.clearRect(0, 0, this.canvas.width, this.canvas.height)
      if (this.isClearBgColor) {
        this.canvas.style.background = 'rgba(255, 255, 255, 0)'
      }
      this.points = [];
      this.hasDrew = false;
      this.resultImg = '';
    }
    function getCropArea(esign,imgData) {
      var topX = esign.canvas.width; var btmX = 0; var topY = esign.canvas.height; var btnY = 0;
      for (var i = 0; i < esign.canvas.width; i++) {
        for (var j = 0; j < esign.canvas.height; j++) {
          var pos = (i + esign.canvas.width * j) * 4
          if (imgData[pos] > 0 || imgData[pos + 1] > 0 || imgData[pos + 2] || imgData[pos + 3] > 0) {
            btnY = Math.max(j, btnY);
            btmX = Math.max(i, btmX);
            topY = Math.min(j, topY);
            topX = Math.min(i, topX);
          }
        }
      }
      topX++;
      btmX++;
      topY++;
      btnY++;
      return [topX, topY, btmX, btnY];
    }

    this.loadImage = function(img){
      var esign = this;
      esign.clear();
      img.onload = function() {
        var minScale = 1.0;
        if(this.height > esign.height){
          var scale = esign.height / this.height;
          minScale = scale;
        }
        if(this.width > esign.width){
          var scale = esign.width / this.width;
          if(minScale > scale){
            minScale = scale;
          }
        }
        esign.canvasCtx.drawImage(img, 0, 0,this.width*minScale,this.height*minScale);
        esign.hasDrew = true;
      }
    }

    this.loadFile = function(file){
      var windowURL = window.URL || window.webkitURL;
      var src = windowURL.createObjectURL(file);
      var img = new Image();
      img.crossOrigin = "";
      img.src=src;
      this.loadImage(img);
      windowURL.revokeObjectURL(src);
    }

    this.loadURL=function(url){
      var windowURL = window.URL || window.webkitURL;
      var img = new Image();
      img.crossOrigin = "";
      img.src=url;
      this.loadImage(img);
    }

    this.generate = function(options) {
      var imgFormat = options && options.format ? options.format: this.format;
      var imgQuality = options && options.quality ? options.quality: this.quality;
      var esign = this;
      if (esign.hasDrew) {
        var resImgData = esign.canvasCtx.getImageData(0, 0, esign.canvas.width, esign.canvas.height);
        esign.canvasCtx.globalCompositeOperation = "destination-over";
        esign.canvasCtx.fillStyle = esign.myBg();
        esign.canvasCtx.fillRect(0,0,esign.canvas.width ,esign.canvas.height);
        esign.resultImg = esign.canvas.toDataURL(imgFormat, imgQuality);
        var resultImg = esign.resultImg;
        esign.canvasCtx.clearRect(0, 0, esign.canvas.width ,esign.canvas.height);
        esign.canvasCtx.putImageData(resImgData, 0, 0);
        esign.canvasCtx.globalCompositeOperation = "source-over";
        if (esign.isCrop) {
          var crop_area = getCropArea(esign,resImgData.data);
          var crop_canvas = document.createElement('canvas');
          var crop_ctx = crop_canvas.getContext('2d');
          crop_canvas.width = crop_area[2] - crop_area[0];
          crop_canvas.height = crop_area[3] - crop_area[1];
          var crop_imgData = esign.canvasCtx.getImageData(...crop_area);
          crop_ctx.globalCompositeOperation = "destination-over"
          crop_ctx.putImageData(crop_imgData, 0, 0);
          crop_ctx.fillStyle = esign.myBg();
          crop_ctx.fillRect(0, 0, crop_canvas.width , crop_canvas.height);
          resultImg = crop_canvas.toDataURL(imgFormat, imgQuality);
          crop_canvas = null;
        }
        return resultImg;
      }else{
        return "";
      }
    }
  }

  var options = {}
  options.lineWidth = ${tag.lineWidth};
  options.width = ${tag.width};
  options.height = ${tag.height};
  var esign_${tag.id} = new Esign(document.getElementById("${tag.id}_canvas"),options);
  esign_${tag.id}.mount();
  document.getElementById('${tag.id}_clear').onclick = function(e){
    esign_${tag.id}.clear();
    document.getElementById('${tag.id}').value="";
    return false;
  }
  function displayImageButton(img){
    img.parentElement.style.display='';
  }
</script>
