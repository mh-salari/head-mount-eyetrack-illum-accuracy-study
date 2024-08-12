# Created on Aug 03 2024
# @author: MohammadHossein Salari
# @email: mohammadHossein.salari@gmail.com

# Load required libraries
library(tidyverse)
library(ggplot2)
library(dplyr)
library(tidyr)

# Load the cleaned data
data <- readRDS("data/cleaned_eye_tracking_data.rds")

# Display the first few rows and structure of the loaded data
head(data)
str(data)

# Basic descriptive statistics
summary(data)

# Calculate mean and std of accuracy for each target point across all illumination conditions
overall_stats <- data %>%
  group_by(target) %>%
  summarise(
    mean_acc = mean(acc, na.rm = TRUE),
    std_acc = sd(acc, na.rm = TRUE)
  ) %>%
  arrange(target)

print("Overall statistics for each target point:")
print(overall_stats)

# Calculate mean and std of accuracy for each target point for each illumination condition
illumination_stats <- data %>%
  group_by(target, ill_recording) %>%
  summarise(
    mean_acc = mean(acc, na.rm = TRUE),
    std_acc = sd(acc, na.rm = TRUE)
  ) %>%
  arrange(target, ill_recording)

print("Statistics for each target point under each illumination condition:")
print(illumination_stats)


# Plot 1: Mean Accuracy by Fixation Target and Illumination Level
# Ensure the target is treated as a factor and in the correct order
illumination_stats$target <- factor(illumination_stats$target, levels = 1:9)

# Create the plot
plot <- ggplot(illumination_stats, aes(x = target, y = mean_acc, color = ill_recording)) +
  geom_vline(xintercept = 1:9, linetype = "dashed", color = "gray90") +
  geom_point(size = 3) +
  scale_color_manual(values = c("Low (Dark)" = "#2C3E50", 
                                "Moderate (Normal)" = "#95A5A6", 
                                "High (Bright)" = "#F4D03F")) +
  scale_x_discrete(limits = factor(1:9)) +
  scale_y_continuous(limits = c(1.5, 4.75), breaks = seq(1.5, 4.5, by = 0.5)) +
  labs(title = "Mean Accuracy by Fixation Target and Illumination Level",
       x = "Fixation Targets",
       y = "Mean Accuracy",
       color = "Illumination Level\nDuring Data Recording:") +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    legend.position = "top",
    legend.justification = "right",
    legend.box.just = "right"
  )

# Display the plot
print(plot)

# Save the plot
ggsave("figures/accuracy_by_target_and_illumination.png", plot, width = 10, height = 6, dpi = 300)


# Plot 2: Accuracy by Illumination Conditions (Targets 5 and 8)
# Filter data for targets 5 and 8
selected_targets_data <- data %>% 
  filter(target %in% c(5, 8))

# Calculate statistics for selected targets
selected_targets_stats <- selected_targets_data %>%
  group_by(target, ill_recording) %>%
  summarise(
    mean_acc = mean(acc, na.rm = TRUE),
    std_acc = sd(acc, na.rm = TRUE)
  ) %>%
  arrange(target, ill_recording)

# Define the color palette and order
ill_colors <- c("Low (Dark)" = "#2C3E50", 
                "Moderate (Normal)" = "#95A5A6", 
                "High (Bright)" = "#F4D03F")

ill_order <- c("Low (Dark)", "Moderate (Normal)", "High (Bright)")

# Ensure correct order of illumination levels
selected_targets_stats$ill_recording <- factor(selected_targets_stats$ill_recording, levels = ill_order)
selected_targets_data$ill_recording <- factor(selected_targets_data$ill_recording, levels = ill_order)
selected_targets_data$ill_calibration <- factor(selected_targets_data$ill_calibration, levels = ill_order)


selected_targets_summary <- selected_targets_data %>%
  group_by(ill_recording, ill_calibration) %>%
  summarise(
    mean_acc = mean(acc, na.rm = TRUE),
    std_acc = sd(acc, na.rm = TRUE),
    q3 = quantile(acc, 0.75, na.rm = TRUE)
  )


plot6 <- ggplot(selected_targets_data, aes(x = ill_recording, y = acc, fill = ill_calibration)) +
  geom_vline(xintercept = 1:3, linetype = "dashed", color = "gray90") +
  geom_boxplot(alpha = 0.7, width = 0.7) +
  geom_text(data = selected_targets_summary, 
            aes(y = q3, 
                label = sprintf("%.2f ± %.2f", mean_acc, std_acc)),
            position = position_dodge(width = 0.7),
            vjust = -0.5, hjust = 0.5, size = 2.8, 
            color = "black", fontface = "bold") +
  scale_fill_manual(values = ill_colors, limits = ill_order) +
  scale_x_discrete(limits = ill_order) +
  labs(title = "Accuracy by Illumination Conditions (Targets 5 and 8)",
       x = "Recording Illumination",
       y = "Accuracy",
       fill = "Calibration Illumination") +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(color = "black"),
    axis.text.x = element_text(angle = 0, hjust = 0.5, vjust = 1, margin = margin(t = 10, b = 10)),
    axis.text.y = element_text(size = 12),
    axis.title.x = element_text(margin = margin(t = 20, b = 5)),
    axis.title.y = element_text(size = 14),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 11),
    plot.title = element_text(size = 16),
    legend.position = "top",
    legend.justification = "right",
    legend.box.just = "right",
    plot.margin = margin(t = 20, r = 20, b = 20, l = 20, unit = "pt")
  ) +
  coord_cartesian(clip = "off")

print(plot6)
ggsave("figures/accuracy_targets_5_8_by_illumination_conditions.png", plot6, width = 12, height = 8, dpi = 300)
