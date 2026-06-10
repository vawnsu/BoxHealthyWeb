package com.boxhealthy.controller;

import com.boxhealthy.dto.ChatRequest;
import com.boxhealthy.dto.ChatResponse;
import com.boxhealthy.service.AiChatService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ChatController {
    private final AiChatService aiChatService;

    public ChatController(AiChatService aiChatService) {
        this.aiChatService = aiChatService;
    }

    @PostMapping("/api/chat")
    public ChatResponse chat(@RequestBody ChatRequest request) {
        return new ChatResponse(aiChatService.reply(request.getMessage()));
    }
}
