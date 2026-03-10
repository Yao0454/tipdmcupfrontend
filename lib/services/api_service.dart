import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 【重要】因为您在使用真机调试，这里必须填入您 Mac 电脑的局域网 IPv4 地址！
  // 例如: 'http://192.168.1.100:5000' (视您的Python后端端口而定)
  static const String baseUrl = 'http://127.0.0.1:1515';

  static Future<String> sendMessage(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {
          'Content-Type': 'application/json', // 假设您的后端接收 JSON
        },
        body: jsonEncode({
          'prompt': prompt, 
        }),
      );

      if (response.statusCode == 200) {
        // 解决中文乱码问题
        final decodedBody = utf8.decode(response.bodyBytes);
        
        // 如果您的后端直接返回纯字符串：
        return decodedBody;
        
        // 如果您的后端返回的是 JSON 格式，如 {"message": "你好"}，请改成下面这样解包：
        // final jsonResponse = jsonDecode(decodedBody);
        // return jsonResponse['message'] ?? '无返回内容';
      } else {
        return '请求失败，状态码: ${response.statusCode}';
      }
    } catch (e) {
      return '网络请求发生错误: $e';
    }
  }
}