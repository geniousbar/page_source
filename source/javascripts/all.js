// This is where it all

var isVisible = false;
function toggleShowWechat(e) {
  if(isVisible) {
    document.getElementById("header-wechat-img").style.visibility="hidden";
  }else {
    document.getElementById("header-wechat-img").style.visibility="visible";
  }
  isVisible = !isVisible;
}

window.toggleShowWechat = toggleShowWechat;
