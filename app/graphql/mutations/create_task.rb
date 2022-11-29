module Mutations
  class CreateTask < BaseMutation
    include GraphqlErrors

    argument :input, Types::Inputs::CreateTaskInput, required: true

    type Types::Payloads::CreateTaskPayload

    def resolve(input:)
      project = Project.find(input.project_id)
      result = Tasks::Create.call(project: project, task_params: input.to_h.except(:project_id))

      if result.success?
        result.to_h.merge({ errors: [] })
      else
        result.to_h.merge({ errors: formatted_errors(result.project) })
      end
    end
  end
end
