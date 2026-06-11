package com.boxhealthy.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class AiChatService {
    private static final String DEEPSEEK_API_URL = "https://api.deepseek.com/chat/completions";
    private static final String GEMINI_API_URL_TEMPLATE =
            "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent";
    private static final String FALLBACK_REPLY =
            "Hiện tại trợ lý AI chưa được cấu hình API key. Bạn có thể bật GEMINI_API_KEY để dùng free tier hoặc DEEPSEEK_API_KEY nếu tài khoản DeepSeek có balance.";
    private static final String SYSTEM_PROMPT =
            "Bạn là trợ lý AI của Box Healthy. Trả lời bằng tiếng Việt, ngắn gọn, thân thiện. Chỉ tư vấn món ăn healthy, TDEE, macro, dinh dưỡng, cách đặt hàng và gợi ý lựa chọn sản phẩm. Không đưa chẩn đoán y khoa.";

    private final String deepseekApiKey;
    private final String deepseekModel;
    private final String geminiApiKey;
    private final String geminiModel;
    private final ObjectMapper objectMapper;
    private final HttpClient httpClient;

    public AiChatService(
            @Value("${deepseek.api-key:${DEEPSEEK_API_KEY:}}") String deepseekApiKey,
            @Value("${deepseek.model:${DEEPSEEK_MODEL:deepseek-chat}}") String deepseekModel,
            @Value("${gemini.api-key:${GEMINI_API_KEY:}}") String geminiApiKey,
            @Value("${gemini.model:${GEMINI_MODEL:gemini-3.1-flash-lite}}") String geminiModel) {
        this.deepseekApiKey = deepseekApiKey;
        this.deepseekModel = deepseekModel;
        this.geminiApiKey = geminiApiKey;
        this.geminiModel = geminiModel;
        this.objectMapper = new ObjectMapper();
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }

    public String reply(String message) {
        String cleanMessage = message == null ? "" : message.trim();
        if (cleanMessage.isBlank()) {
            return "Bạn muốn mình gợi ý món ăn, tính macro, hay tư vấn chọn box healthy?";
        }
        if (cleanMessage.length() > 600) {
            return "Bạn nhắn ngắn hơn một chút giúp mình nhé, khoảng dưới 600 ký tự là đẹp.";
        }
        if (geminiApiKey != null && !geminiApiKey.isBlank()) {
            return replyWithGemini(cleanMessage);
        }
        if (deepseekApiKey != null && !deepseekApiKey.isBlank()) {
            return replyWithDeepSeek(cleanMessage);
        }
        return FALLBACK_REPLY;
    }

    private String replyWithGemini(String cleanMessage) {
        try {
            Map<String, Object> payload = Map.of(
                    "systemInstruction", Map.of("parts", List.of(Map.of("text", SYSTEM_PROMPT))),
                    "contents", List.of(Map.of(
                            "role", "user",
                            "parts", List.of(Map.of("text", cleanMessage))
                    )),
                    "generationConfig", Map.of(
                            "temperature", 0.7,
                            "maxOutputTokens", 450
                    )
            );
            String requestBody = objectMapper.writeValueAsString(payload);
            String encodedModel = URLEncoder.encode(geminiModel, StandardCharsets.UTF_8);
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(String.format(GEMINI_API_URL_TEMPLATE, encodedModel)))
                    .timeout(Duration.ofSeconds(35))
                    .header("Content-Type", "application/json")
                    .header("x-goog-api-key", geminiApiKey)
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() < 200 || response.statusCode() >= 300) {
                return geminiErrorMessage(response.statusCode());
            }

            JsonNode content = objectMapper.readTree(response.body())
                    .path("candidates").path(0).path("content").path("parts").path(0).path("text");
            if (content.isMissingNode() || content.asText().isBlank()) {
                return "Mình chưa tạo được câu trả lời phù hợp. Bạn hỏi lại theo cách khác nhé.";
            }
            return content.asText();
        } catch (InterruptedException ex) {
            Thread.currentThread().interrupt();
            return "Kết nối AI bị gián đoạn. Bạn thử lại sau một chút nhé.";
        } catch (Exception ex) {
            return "AI Gemini đang lỗi kết nối tạm thời. Bạn thử lại sau một chút nhé.";
        }
    }

    private String replyWithDeepSeek(String cleanMessage) {
        try {
            Map<String, Object> payload = Map.of(
                    "model", deepseekModel,
                    "messages", List.of(
                            Map.of("role", "system", "content", SYSTEM_PROMPT),
                            Map.of("role", "user", "content", cleanMessage)
                    ),
                    "temperature", 0.7,
                    "max_tokens", 450,
                    "stream", false
            );
            String requestBody = objectMapper.writeValueAsString(payload);
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(DEEPSEEK_API_URL))
                    .timeout(Duration.ofSeconds(35))
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + deepseekApiKey)
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() < 200 || response.statusCode() >= 300) {
                return deepseekErrorMessage(response.statusCode());
            }

            JsonNode content = objectMapper.readTree(response.body())
                    .path("choices").path(0).path("message").path("content");
            if (content.isMissingNode() || content.asText().isBlank()) {
                return "Mình chưa tạo được câu trả lời phù hợp. Bạn hỏi lại theo cách khác nhé.";
            }
            return content.asText();
        } catch (InterruptedException ex) {
            Thread.currentThread().interrupt();
            return "Kết nối AI bị gián đoạn. Bạn thử lại sau một chút nhé.";
        } catch (Exception ex) {
            return "AI DeepSeek đang lỗi kết nối tạm thời. Bạn thử lại sau một chút nhé.";
        }
    }

    private String geminiErrorMessage(int statusCode) {
        if (statusCode == 400) {
            return "Gemini API chưa nhận model hoặc nội dung request. Bạn kiểm tra GEMINI_MODEL trên server nhé.";
        }
        if (statusCode == 401 || statusCode == 403) {
            return "Gemini API key chưa hợp lệ hoặc chưa được cấp quyền. Bạn kiểm tra lại GEMINI_API_KEY nhé.";
        }
        if (statusCode == 429) {
            return "Gemini free tier đang bị giới hạn lượt gọi. Bạn thử lại sau một chút nhé.";
        }
        return "AI Gemini đang lỗi mã " + statusCode + ". Bạn thử lại sau một chút nhé.";
    }

    private String deepseekErrorMessage(int statusCode) {
        if (statusCode == 401) {
            return "API key DeepSeek chưa hợp lệ hoặc đã bị xóa. Bạn kiểm tra lại DEEPSEEK_API_KEY trên server nhé.";
        }
        if (statusCode == 402) {
            return "Tài khoản DeepSeek chưa có balance để gọi API. Bạn kiểm tra Billing trên DeepSeek nhé.";
        }
        if (statusCode == 429) {
            return "AI DeepSeek đang bị giới hạn lượt gọi. Bạn thử lại sau một chút nhé.";
        }
        return "AI DeepSeek đang lỗi mã " + statusCode + ". Bạn thử lại sau một chút nhé.";
    }
}
