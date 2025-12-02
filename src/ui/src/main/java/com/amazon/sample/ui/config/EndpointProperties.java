package com.amazon.sample.ui.config;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value; // Import needed for @Value
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties("retail.ui.endpoints")
@Data
public class EndpointProperties {

  @Value("${retail.ui.endpoints.catalog:http://retail-store.local}") // FIX 1: Remove hardcoded port
  private String catalog;

  @Value("${retail.ui.endpoints.carts:http://retail-store.local}") // FIX 2: Remove hardcoded port
  private String carts;

  @Value("${retail.ui.endpoints.checkout:http://retail-store.local}") // Assuming this was also wrong
  private String checkout;

  @Value("${retail.ui.endpoints.orders:http://retail-store.local}") // Assuming this was also wrong
  private String orders;
}
