
function init() {
  mjpeg_img = document.getElementById("mjpeg_dest");
	setInterval(function(){ 
	    mjpeg_img.setAttribute("src","cam_pic.php?time=" + new Date().getTime());
	}, 200);
}
