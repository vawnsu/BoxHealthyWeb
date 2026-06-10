package com.boxhealthy.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class AiChatService {
    private static final String API_URL = "https://api.deepseek.com/chat/completions";
    private static final String FALLBACK_REPLY = "Hiện tại trợ lý AI chưa được cấu hình API key. Bạn vẫn có thể hỏi về thực đơn, TDEE hoặc dinh dưỡng sau khi admin bật DEEPSEEK_API_KEY.";

    private final String apiKey;
    private final String model;
    private final ObjectMapper objectMapper;
    private final HttpClient httpClient;

    public AiChatService(
            @Value("${deepseek.api-key:${DEEPSEEK_API_KEY:}}") String apiKey,
            @Value("${deepseek.model:${DEEPSEEK_MODEL:deepseek-v4-flash}}") String model,
            ObjectMapper objectMapper) {
        this.apiKey = apiKey;
        this.model = model;
        this.objectMapper = objectMapper;
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
        if (apiKey == null || apiKey.isBlank()) {
            return FALLBACK_REPLY;
        }

        try {
            Map<String, Object> payload = Map.of(
                    "model", model,
                    "messages", List.of(
                            Map.of(
                                    "role", "system",
                                    "content", "Bạn là trợ lý AI của Box Healthy. Trả lời bằng tiếng Việt, ngắn gọn, thân thiện. Chỉ tư vấn món ăn healthy, TDEE, macro, dinh dưỡng, cách đặt hàng và gợi ý lựa chọn sản phẩm. Không đưa chẩn đoán y khoa."),
                            Map.of("role", "user", "content", cleanMessage)
                    ),
                    "temperature", 0.7,
                    "max_tokens", 450,
                    "stream", false
            );
            String requestBody = objectMapper.writeValueAsString(payload);
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(API_URL))
                    .timeout(Duration.ofSeconds(35))
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + apiKey)
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() < 200 || response.statusCode() >= 300) {
                return "AI đang bận hoặc API key chưa hợp lệ. Bạn thử lại sau một chút nhé.";
            }

            JsonNode root = objectMapper.readTree(response.body());
            JsonNode content = root.path("choices").path(0).path("message").path("content");
            if (content.isMissingNode() || content.asText().isBlank()) {
                return "Mình chưa tạo được câu trả lời phù hợp. Bạn hỏi lại theo cách khác nhé.";
            }
            return content.asText();
        } catch (InterruptedException ex) {
            Thread.currentThread().interrupt();
            return "Kết nối AI bị gián đoạn. Bạn thử lại sau một chút nhé.";
        } catch (Exception ex) {
            return "AI đang lỗi kết nối tạm thời. Bạn thử lại sau một chút nhé.";
        }
    }
}
