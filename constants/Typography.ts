import { Platform } from 'react-native';

export const Typography = {
  fonts: {
    heading: Platform.select({
      web: 'Playfair Display, serif',
      default: 'PlayfairDisplay',
    }),
    body: Platform.select({
      web: 'Roboto, sans-serif',
      default: 'Roboto',
    }),
  },
  weights: {
    regular: '400',
    medium: '500',
    bold: '700',
  },
  sizes: {
    xs: 12,
    sm: 14,
    md: 16,
    lg: 18,
    xl: 20,
    xxl: 24,
    xxxl: 32,
    display: 40,
  },
  lineHeights: {
    heading: 1.2, // 120%
    body: 1.5, // 150%
  },
};

export default Typography;