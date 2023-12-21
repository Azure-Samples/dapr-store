import { describe, it, vi, expect } from 'vitest'
import { mount, flushPromises } from '@vue/test-utils'
import router from '@/router'

import ProductSearch from '@/views/ProductSearch.vue'

vi.mock('@/services/api')

describe('ProductSearch.vue', () => {
  it('renders search for Ascot', async () => {
    router.push('/search/Ascot')
    await router.isReady()

    const wrapper = mount(ProductSearch, {
      global: {
        plugins: [router]
      }
    })

    await flushPromises()
    expect(wrapper.html()).toMatchSnapshot()
  })
})
