package cn.roothub.web.admin;

import java.util.Map;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import cn.roothub.dto.PageDataBody;
import cn.roothub.service.ReplyService;

/**
 * <p></p>
 * @author: miansen.wang
 * @date: 2019-03-30
 */
@Controller
@RequestMapping("/admin/reply")
public class ReplyAdminController {

	@Autowired
	private ReplyService replyService;
	
	/**
	 * 后台评论列表
	 * @param author: 评论用户
	 * @param topic: 话题
	 * @param startDate: 开始时间
	 * @param endDate: 结束时间
	 * @param p: 页数
	 * @param model
	 * @return
	 */
	@RequiresPermissions("reply:list")
	@RequestMapping(value = "/list",method = RequestMethod.GET)
	public String list(@RequestParam(value = "author",required = false) String author,
					   @RequestParam(value = "topic",required = false) String topic,
					   @RequestParam(value = "startDate",required = false) String startDate,
					   @RequestParam(value = "endDate",required = false) String endDate,
					   @RequestParam(value = "p",required = false,defaultValue = "1") Integer p,Model model) {
	    if (StringUtils.isEmpty(author)) author = null;
	    if (StringUtils.isEmpty(topic)) topic = null;
	    if (StringUtils.isEmpty(startDate)) startDate = null;
	    if (StringUtils.isEmpty(endDate)) endDate = null;
	    PageDataBody<Map<String, Object>> page = replyService.pageForAdmin(author, topic, startDate, endDate, p, 25);
	    model.addAttribute("page", page);
	    model.addAttribute("author", author);
	    model.addAttribute("topic", topic);
	    model.addAttribute("startDate", startDate);
	    model.addAttribute("endDate", endDate);
	    model.addAttribute("p", p);
	    return "admin/reply/list";
	}
	
}