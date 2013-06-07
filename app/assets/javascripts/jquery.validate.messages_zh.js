/*
 * Translated default messages for the jQuery validation plugin.
 * Locale: ZH (Chinese, 中文 (Zhōngwén), 汉语, 漢語)
 */
(function ($) {
	$.extend($.validator.messages, {
		required: "必填",
		remote: "*",
		email: "电子邮件格式不正确",
		url: "网址格式不正确",
		date: "日期格式不正确",
		dateISO: "日期(ISO)格式不正确",
		number: "数字格式不正确",
		digits: "只能输入整数",
		creditcard: "信用卡号格式不正确",
		equalTo: "两次输入不同",
		accept: "格式不支持",
		maxlength: $.validator.format("最长长度为 {0} 位"),
		minlength: $.validator.format("最短长度为 {0} 位"),
		rangelength: $.validator.format("长度必须介于 {0} 和 {1} 之间"),
		range: $.validator.format("长度必须介于 {0} 和 {1} 之间的值"),
		max: $.validator.format("最大 {0}"),
		min: $.validator.format("最小 {0}")
	});
}(jQuery));
