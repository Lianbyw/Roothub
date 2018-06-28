<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
<title>${topic.title}</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<!-- 引入 Bootstrap -->
<link href="/resources/css/bootstrap.min.css" rel="stylesheet">
<link href="/resources/css/app.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="/resources/wangEditor/wangEditor.min.css">
<link rel="shortcut icon" href="/resources/images/favicon.ico">
<script src="/resources/js/logout.js"></script>
</head>
<body>
	<div class="wrapper">
		<jsp:include page="../components/head.jsp"></jsp:include>
		<div class="panel panel-default">
			<div class="panel-body topic-detail-header">
				<div class="media">
					<div class="media-body">
						<h2 class="topic-detail-title">${topic.title}</h2>
						<p class="gray">
						<!-- 点赞点踩功能，后续在开发吧 -->
							<!-- <i id="up_icon_1"
								class="fa fa-chevron-up
                up-down-disable "
								onclick="voteTopic('UP')"></i> <i id="down_icon_1"
								class="fa fa-chevron-down
                up-down-disable "
								onclick="voteTopic('DOWN')"></i> <span id="up_down_vote_count_1">0</span> -->
							<!-- <span>•</span>  -->
							<c:if test="${topic.top}">
							<span class="label label-primary">置顶</span> <span>•</span>
							</c:if>
							<c:if test="${topic.good}">
							<span class="label label-primary">精华</span> <span>•</span>
							</c:if>
							<span><a href="/user/${topic.author}">${topic.author}</a></span> <span>•</span>
							<span><fmt:formatDate type="both" dateStyle="medium"
									timeStyle="short" value="${topic.createDate}" /></span> <span>•</span>
							<span>${topic.viewCount}次点击</span>
						</p>
					</div>
					<div class="media-right">
						<img
							src="/resources/images/${topic.avatar}"
							class="avatar-lg">
					</div>
				</div>
			</div>
			<div class="divide"></div>
			<div class="panel-body topic-detail-content show_big_image">
				${topic.content}
				<div>
					<a href="/topic/tag/${topic.tag}"><span class="label label-success">${topic.tag}</span></a>
				</div>
			</div>
			<div class="panel-footer">
				<a
					href="javascript:window.open('http://service.weibo.com/share/share.php?url=https://yiiu.co//topic/1?r=public&amp;title=YIIU功能一览图', '_blank', 'width=550,height=370'); recordOutboundLink(this, 'Share', 'weibo.com');">分享微博</a>&nbsp;
				<a href="javascript:;" class="collectTopic">加入收藏</a> <span
					class="pull-right"><span id="collectCount">2</span>个收藏</span>
			</div>
		</div>
		<c:if test="${topic.replyCount == 0}">
		<div class="panel panel-default">
			<div class="panel-body text-center">目前暂无评论</div>
		</div>
		</c:if>
		<c:if test="${topic.replyCount > 0}">
		<jsp:include page="../reply/replies.jsp"></jsp:include>
		</c:if>
		<div class="panel panel-default" id="pinglun" style="display: none">
			<div class="panel-heading">
				添加一条新评论 <a href="javascript:;" id="goTop" class="pull-right">回到顶部</a>
			</div>
			<div class="panel-body">
				<input type="hidden" id="commentId" value="">
				<p class="hidden" id="replyP">
					回复<span id="replyAuthor"></span>: <a
						href="javascript:cancelReply();">取消</a>
				</p>
				<body>
				</body>
				<div id="editor" style="margin-bottom: 10px;"></div>
				<button id="btn" class="btn btn-sm btn-default">
					<!-- <span class="glyphicon glyphicon-send"></span> --> 评论
				</button>
			</div>
		</div>
	</div>
	</div>
	</div>
	<jsp:include page="../components/foot.jsp"></jsp:include>
	<!-- jQuery (Bootstrap 的 JavaScript 插件需要引入 jQuery) -->
	<script src="/resources/js/jquery.js"></script>
	<!-- 引入 Bootstrap -->
	<script src="/resources/js/bootstrap.min.js"></script>
	<script src="/resources/wangEditor/wangEditor.min.js"></script>
	<script type="text/javascript">
      $.ajax({
        type:"get",
        url:"/session",
        dataType:"json",
        success:function(data){
          if(data.success != null && data.success == true){
                $("#pinglun").show();
          }
          if(data.success != null && data.success == false){
            
          }
        },
        error:function(data){

        }
      });
    
  var E = window.wangEditor;
  var editor = new E('#editor');
  editor.customConfig.debug = true;
  editor.customConfig.uploadFileName = 'file';
  editor.customConfig.uploadImgServer = '/common/wangEditorUpload';
  editor.customConfig.menus = [
    'head',  // 标题
    'bold',  // 粗体
    'italic',  // 斜体
    'list',  // 列表
    'emoticon',  // 表情
    'image',  // 插入图片
    'table',  // 表格
    ];
    editor.create();

    function commentThis(username, commentId) {
      $("#replyAuthor").text(username);
      $("#commentId").val(commentId);
      $("#replyP").removeClass("hidden");
    }

    function cancelReply() {
      $("#replyAuthor").text("");
      $("#commentId").val("");
      $("#replyP").addClass("hidden");
    }
    
    $("#btn").click(function () {
        var contentHtml = editor.txt.html();
        var contentText = editor.txt.text();
        var topicId = ${topic.topicId};
        if(!contentText) {
          alert('请输入回复内容哦');
          return false;
      } else {
        $.ajax({
          url: '/reply/save',
          type: 'post',
          dataType: 'json',
          data: {
            content: contentText ? contentHtml : '',
            topicId: topicId
          },
          success: function(data){
            if(data.success != null && data.success == true) {
              window.location.href = "/topic/" + data.data.reply.topicId;
            } else {
              alert(data.data.error);
            }
          }
        })
      }
    });
  </script>
</body>
</html>