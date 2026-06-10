package com.boxhealthy.service;

import com.boxhealthy.dto.CartItemDto;
import com.boxhealthy.entity.Cart;
import com.boxhealthy.entity.CartItem;
import com.boxhealthy.entity.Product;
import com.boxhealthy.entity.User;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import com.boxhealthy.repository.CartItemRepository;
import com.boxhealthy.repository.CartRepository;
import org.springframework.stereotype.Service;

@Service
public class CartService {
    private static final String CART_KEY = "CART";
    private final ProductService productService;
    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;

    public CartService(ProductService productService, CartRepository cartRepository,
                       CartItemRepository cartItemRepository) {
        this.productService = productService;
        this.cartRepository = cartRepository;
        this.cartItemRepository = cartItemRepository;
    }

    @SuppressWarnings("unchecked")
    public Map<Long, CartItemDto> getCart(HttpSession session) {
        Object cart = session.getAttribute(CART_KEY);
        if (cart == null) {
            Map<Long, CartItemDto> newCart = new LinkedHashMap<>();
            session.setAttribute(CART_KEY, newCart);
            return newCart;
        }
        return (Map<Long, CartItemDto>) cart;
    }

    public void add(HttpSession session, Long productId) {
        Product product = productService.getById(productId);
        Map<Long, CartItemDto> cart = getCart(session);
        CartItemDto item = cart.get(productId);
        if (item == null) {
            cart.put(productId, new CartItemDto(product, 1));
        } else {
            item.setQuantity(item.getQuantity() + 1);
        }
    }

    @Transactional
    public void add(HttpSession session, User user, Long productId) {
        if (user == null) {
            add(session, productId);
            return;
        }
        Product product = productService.getById(productId);
        Cart cart = getOrCreateCart(user);
        CartItem item = cartItemRepository.findByCartAndProductId(cart, productId).orElse(null);
        if (item == null) {
            item = new CartItem();
            item.setCart(cart);
            item.setProduct(product);
            item.setQuantity(1);
        } else {
            item.setQuantity(item.getQuantity() + 1);
        }
        cartItemRepository.save(item);
    }

    public void update(HttpSession session, Long productId, int quantity) {
        Map<Long, CartItemDto> cart = getCart(session);
        if (quantity <= 0) {
            cart.remove(productId);
        } else if (cart.containsKey(productId)) {
            cart.get(productId).setQuantity(quantity);
        }
    }

    @Transactional
    public void update(HttpSession session, User user, Long productId, int quantity) {
        if (user == null) {
            update(session, productId, quantity);
            return;
        }
        Cart cart = getOrCreateCart(user);
        cartItemRepository.findByCartAndProductId(cart, productId).ifPresent(item -> {
            if (quantity <= 0) {
                cartItemRepository.delete(item);
            } else {
                item.setQuantity(quantity);
                cartItemRepository.save(item);
            }
        });
    }

    public void remove(HttpSession session, Long productId) {
        getCart(session).remove(productId);
    }

    @Transactional
    public void remove(HttpSession session, User user, Long productId) {
        if (user == null) {
            remove(session, productId);
            return;
        }
        Cart cart = getOrCreateCart(user);
        cartItemRepository.findByCartAndProductId(cart, productId).ifPresent(cartItemRepository::delete);
    }

    public Collection<CartItemDto> getItems(HttpSession session) {
        return getCart(session).values();
    }

    public Collection<CartItemDto> getItems(HttpSession session, User user) {
        if (user == null) {
            return getItems(session);
        }
        Cart cart = getOrCreateCart(user);
        List<CartItemDto> items = new ArrayList<>();
        for (CartItem item : cartItemRepository.findByCart(cart)) {
            items.add(new CartItemDto(item.getProduct(), item.getQuantity()));
        }
        return items;
    }

    public BigDecimal getTotal(HttpSession session) {
        return getItems(session).stream()
                .map(CartItemDto::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public BigDecimal getTotal(HttpSession session, User user) {
        return getItems(session, user).stream()
                .map(CartItemDto::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public void clear(HttpSession session) {
        session.removeAttribute(CART_KEY);
    }

    @Transactional
    public void clear(HttpSession session, User user) {
        if (user == null) {
            clear(session);
            return;
        }
        Cart cart = getOrCreateCart(user);
        cartItemRepository.deleteByCart(cart);
    }

    @Transactional
    public void mergeSessionCartToUser(HttpSession session, User user) {
        if (user == null) {
            return;
        }
        Collection<CartItemDto> sessionItems = getItems(session);
        if (sessionItems.isEmpty()) {
            return;
        }
        for (CartItemDto item : sessionItems) {
            for (int i = 0; i < item.getQuantity(); i++) {
                add(session, user, item.getProduct().getId());
            }
        }
        clear(session);
    }

    private Cart getOrCreateCart(User user) {
        return cartRepository.findByUser(user).orElseGet(() -> {
            Cart cart = new Cart();
            cart.setUser(user);
            return cartRepository.save(cart);
        });
    }
}
