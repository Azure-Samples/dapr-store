import js from '@eslint/js'
import globals from 'globals'
import pluginVue from 'eslint-plugin-vue'
import { defineConfig } from 'eslint/config'

export default defineConfig([
  {
    files: ['**/*.{js,mjs,cjs,vue}'],
    plugins: { js },
    extends: ['js/recommended'],
    rules: {
      'no-unused-vars': ['error', { argsIgnorePattern: '^_', varsIgnorePattern: '^_', caughtErrorsIgnorePattern: '^_' }]
    }
  },
  { files: ['**/*.{js,mjs,cjs,vue}'], languageOptions: { globals: globals.browser } },
  pluginVue.configs['flat/essential'],
  {
    rules: {
      'vue/multi-word-component-names': 'off'
    }
  }
])
