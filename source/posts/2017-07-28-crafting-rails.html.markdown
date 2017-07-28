---
title: crafting rails
date: 2017-07-28
tags: rails, ruby
---
crafting rails application
--------

### 创建自己的render

  * rails plugins new pdf_render
  * gemspec, 之盾依赖， 作者、version， lib/pef_render.rb会被自动require（详细看bundler.io中的解释）
  * Gemfile, 直接引入gemspec，生命依赖关系

  rails render 解析

  ```ruby
  # rails/actionpac k/lib/action_controller/metal/rendcers.rb

  add :json do |json, options|
    json = json.to_json(options) unless json.kind_of?(String)

    if options[:callback].present?
      self.content_type ||= Mime::JS
      "#{options[:callback]}(#{json})"
    else
      self.content_type |||= Mime::JSON
      self
    end
  end

  render json: @post
  json  => @post# json 指的是， block中的json的变量
  # 我们想提供的为
  render pdf: 'contents', template: 'path/to/template'

  require 'prawn'  # prawn 提供 pdf的生成
  pdf = Prawn::Document.new
  pdf.text('a string to pdf')
  pdf.render_file('sample.pdf')


  # lib/pdf_render.rb
  require 'prawn'
  ActionController::Renderers.add :pdf do |filename, options|
    pdf = Prawn::Document.new
    pdf.text = render_to_string(options)
    send_data(pdf.render, filename: "#{filename}.pdf", diposition: "attachment")
  end

  # rails 如何设定正确的respon中的content type？
  Mime::Type.register "application/pdf", :pdf, [], %w(pdf)
  ```

  rails render stack

  ```text
   AbstractController::Rendering.render
   |
   |-- _normalize_render
   |      |-- _normalize_args
   |      |-- _normalize_opions
   |-- ActionView::Rending.render_to_body
          |-- _proccess_options
          |-- _render_template
                  |-- context = view_context_class.new(view_renderer, view_assigns, self)
                  |-- ActionView::Renderer.new(lookup_context).render(context, option)
                      |-- Renderer.render_template(context, options)
                          |-- TemplateRenderer.new(@lookup_context).render(context, options)

  其中, 大部分的都是在ActionController::Base 中include进去的，所以。所有方法都是在controller中执行的
    def view_assigns
      protected_vars = _protected_ivars
      variables      = instance_variables

      variables.reject! { || sprotected_vars.include?  }
      svariables.each_with_object({}) { |name, hash|
        hash[name.slice(1, name.length)] = instance_variable_get(name)
      }
    end
    获取controller中所有的实例变量, 传递到 context中
  ```

### 通过Active Model建立自己的模型

  1. form_helper

  ```
  form_for(record, options)
  |-- builder = instantiate_builder(object_name, record, options)
      |-- builder = options[:builder] || default_form_builder_class # ActionView::Helpers::FormBuilder
      |-- builder.new(object_name, object, self, options) # self is ActionView::Base instance
  |-- output = capture(builder, &block) # form_for中的内部dom
      |-- yield(builder)
        |-- Tags::TextField.new("data_bank", :title, self, {object: object}).render
          |-- options["value"] = options.fetch("value") { value_before_type_cast(object) }
            |-- value_before_type_cast # 从object获取method_name的数值
  |-- form_tag_with_body(html_options, output) # 构建真正的form dom
  ```

  **所以rails中的文档有很明确的拓展方法:**

  ```ruby
  class MyFormBuilder < ActionView::Helpers::FormBuilder
    def div_radio_button(method, tag_value, options = {})
      @template.content_tag(:div,
        @template.radio_button(
          @object_name, method, tag_value, objectify_options(options)
        )
      )
    end
  end

  # The above code creates a new method +div_radio_button+ which wraps a div
  # around the new radio button. Note that when options are passed in, you
  # must call +objectify_options+ in order for the model object to get
  # correctly passed to the method. If +objectify_options+ is not called,
  # then the newly created helper will not be linked back to the model.
  #   <%= form_for @person, :builder => MyFormBuilder do |f| %>
  #     I am a child: <%= f.div_radio_button(:admin, "child") %>
  #     I am an adult: <%= f.div_radio_button(:admin, "adult") %>
  #   <% end -%>

  ```

  使用继承类，定义自定义的方法， 其他的自然使用继承的方法调用

  > 1. 如何扩展 FormBuilder， 2： FormBuilder 在编辑时候的，默认值，是如何取到的
