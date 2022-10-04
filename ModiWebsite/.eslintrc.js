module.exports = {
  "env": {
    "browser": true,
    "es2021": true,
  },
  "extends": [
    "google",
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": 13,
    "sourceType": "module",
  },
  "plugins": [
    "@typescript-eslint",
  ],
  "rules": {
    "quotes": ["error", "double"],
    "linebreak-style": "off",
    "require-jsdoc": "off",
    "object-curly-spacing": ["error", "always"],
    "max-len": "off",
    "new-cap": "off",
  },
};
