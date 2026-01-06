# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/anamnestic_forms', type: :request do
  let(:user_admin) { create(:user_admin) }
  let(:user_patient) { create(:user_patient) }
  let(:user_doctor) { create(:user_doctor) }
  let!(:patient) { create(:patient, user: user_patient, gender: 'male') }

  path '/api/v1/anamnestic_forms' do
    get('list anamnestic_forms') do
      tags 'Anamnestic form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :items_per_page, in: :query, schema: {
        type: :integer,
        description: 'Number of items per page',
        example: '20'
      }

      parameter name: :page_param, in: :query, schema: {
        type: :integer,
        description: 'Current page number',
        example: '1'
      }

      let(:items_per_page) { 30 }
      let(:page_param) { 1 }

      response(200, 'successful') do
        authorization_as_admin
        schema type: :object, properties: {
                                pagination: {
                                  type: :object,
                                  properties: {
                                    count: { type: :integer },
                                    page: { type: :integer },
                                    next: { type: :integer, nullable: true },
                                    pages: { type: :integer },
                                    items: { type: :integer }
                                  },
                                  required: ['count', 'page', 'pages', 'items', 'next']
                                },
                                anamnestic_forms: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                      age: { type: :integer },
                                      height: { type: :integer },
                                      weight: { type: :integer },
                                      on_oab_medication_last_3_months: { type: :boolean },
                                      number_of_births: { type: :integer },
                                      post_menopausal: { type: :boolean },
                                      prolapse_diagnosed: { type: :boolean },
                                      hysterectomy: { type: :boolean },
                                      cesarean_section: { type: :string, enum: ['true', 'false', 'no_birth'] },
                                      surgery_for_benign_prostate_enlargement: { type: :boolean },
                                      surgery_for_prostate_cancer: { type: :boolean },
                                      surgery_for_bladder_tumor: { type: :boolean },
                                      surgery_for_urethral_stricture: { type: :boolean },
                                      surgery_for_urine_leakage: { type: :boolean },
                                      no_surgery: { type: :boolean },
                                      other_surgery: { type: :boolean },
                                      previous_surgery_details: { type: :string },
                                      recurrent_infections: { type: :boolean },
                                      neurological_surgery_history: { type: :boolean },
                                      hypertension: { type: :boolean },
                                      hypothyroidism: { type: :boolean },
                                      high_cholesterol: { type: :boolean },
                                      diabetes: { type: :boolean },
                                      back_problems: { type: :boolean },
                                      depression: { type: :boolean },
                                      other_psychiatric_conditions: { type: :boolean },
                                      reduced_immunity: { type: :boolean },
                                      headaches: { type: :boolean },
                                      hip_osteoarthritis: { type: :boolean },
                                      knee_osteoarthritis: { type: :boolean },
                                      cancer_treatment_history: { type: :boolean },
                                      cervical_cancer: { type: :boolean },
                                      endometrial_cancer: { type: :boolean },
                                      ovarian_cancer: { type: :boolean },
                                      breast_cancer: { type: :boolean },
                                      intestinal_cancer: { type: :boolean },
                                      other_cancer: { type: :boolean },
                                      cancer_type_details: { type: :string },
                                      drug_allergies: { type: :boolean },
                                      drug_allergies_details: { type: :string },
                                      glaucoma_or_eye_pressure_meds: { type: :boolean },
                                      cardiac_conditions: { type: :boolean },
                                      heart_attack: { type: :boolean },
                                      arrhythmia: { type: :boolean },
                                      stroke: { type: :boolean },
                                      digestive_problems: { type: :boolean },
                                      dry_mucous_membranes: { type: :boolean },
                                      no_illness: { type: :boolean },
                                      current_medications: { type: :boolean },
                                      current_medications_details: { type: :string },
                                      past_medications: { type: :boolean },
                                      past_medications_details: { type: :string },
                                      completed: { type: :boolean },
                                      id: { type: :integer }
                                    },
                                    required: ['id', 'completion_timestamp', 'age', 'height', 'weight', 'no_illness', 'no_surgery',
                                               'on_oab_medication_last_3_months', 'number_of_births', 'post_menopausal', 'prolapse_diagnosed',
                                               'hysterectomy', 'cesarean_section', 'surgery_for_benign_prostate_enlargement',
                                               'surgery_for_prostate_cancer', 'surgery_for_bladder_tumor', 'surgery_for_urethral_stricture',
                                               'surgery_for_urine_leakage', 'other_surgery', 'previous_surgery_details', 'recurrent_infections',
                                               'neurological_surgery_history', 'hypertension', 'hypothyroidism', 'high_cholesterol',
                                               'diabetes', 'back_problems', 'depression', 'other_psychiatric_conditions', 'reduced_immunity',
                                               'headaches', 'hip_osteoarthritis', 'knee_osteoarthritis', 'cancer_treatment_history',
                                               'cervical_cancer', 'endometrial_cancer', 'ovarian_cancer', 'breast_cancer', 'intestinal_cancer',
                                               'other_cancer', 'cancer_type_details', 'drug_allergies', 'drug_allergies_details',
                                               'glaucoma_or_eye_pressure_meds', 'cardiac_conditions', 'heart_attack', 'arrhythmia', 'stroke',
                                               'digestive_problems', 'dry_mucous_membranes', 'current_medications', 'current_medications_details',
                                               'past_medications', 'past_medications_details', 'completed']
                                  }
                                }
                              },
               required: ['anamnestic_forms', 'pagination']
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(404, 'not found') do
        authorization_as_doctor
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(200, 'successful') do
        authorization_as_patient
        schema type: :object, properties: {
                                pagination: {
                                  type: :object,
                                  properties: {
                                    count: { type: :integer },
                                    page: { type: :integer },
                                    next: { type: :integer, nullable: true },
                                    pages: { type: :integer },
                                    items: { type: :integer }
                                  },
                                  required: ['count', 'page', 'pages', 'items', 'next']
                                },
                                anamnestic_forms: {
                                  type: :array,
                                  items: {
                                    type: :object,
                                    properties: {
                                      completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                      age: { type: :integer },
                                      height: { type: :integer },
                                      weight: { type: :integer },
                                      on_oab_medication_last_3_months: { type: :boolean },
                                      number_of_births: { type: :integer },
                                      post_menopausal: { type: :boolean },
                                      prolapse_diagnosed: { type: :boolean },
                                      hysterectomy: { type: :boolean },
                                      cesarean_section: { type: :string, enum: ['true', 'false', 'no_birth'] },
                                      surgery_for_benign_prostate_enlargement: { type: :boolean },
                                      surgery_for_prostate_cancer: { type: :boolean },
                                      surgery_for_bladder_tumor: { type: :boolean },
                                      surgery_for_urethral_stricture: { type: :boolean },
                                      surgery_for_urine_leakage: { type: :boolean },
                                      no_surgery: { type: :boolean },
                                      other_surgery: { type: :boolean },
                                      previous_surgery_details: { type: :string },
                                      recurrent_infections: { type: :boolean },
                                      neurological_surgery_history: { type: :boolean },
                                      hypertension: { type: :boolean },
                                      hypothyroidism: { type: :boolean },
                                      high_cholesterol: { type: :boolean },
                                      diabetes: { type: :boolean },
                                      back_problems: { type: :boolean },
                                      depression: { type: :boolean },
                                      other_psychiatric_conditions: { type: :boolean },
                                      reduced_immunity: { type: :boolean },
                                      headaches: { type: :boolean },
                                      hip_osteoarthritis: { type: :boolean },
                                      knee_osteoarthritis: { type: :boolean },
                                      cancer_treatment_history: { type: :boolean },
                                      cervical_cancer: { type: :boolean },
                                      endometrial_cancer: { type: :boolean },
                                      ovarian_cancer: { type: :boolean },
                                      breast_cancer: { type: :boolean },
                                      intestinal_cancer: { type: :boolean },
                                      other_cancer: { type: :boolean },
                                      cancer_type_details: { type: :string },
                                      drug_allergies: { type: :boolean },
                                      drug_allergies_details: { type: :string },
                                      glaucoma_or_eye_pressure_meds: { type: :boolean },
                                      cardiac_conditions: { type: :boolean },
                                      heart_attack: { type: :boolean },
                                      arrhythmia: { type: :boolean },
                                      stroke: { type: :boolean },
                                      digestive_problems: { type: :boolean },
                                      dry_mucous_membranes: { type: :boolean },
                                      no_illness: { type: :boolean },
                                      current_medications: { type: :boolean },
                                      current_medications_details: { type: :string },
                                      past_medications: { type: :boolean },
                                      past_medications_details: { type: :string },
                                      completed: { type: :boolean },
                                      id: { type: :integer }
                                    },
                                    required: ['id', 'completion_timestamp', 'age', 'height', 'weight', 'no_illness', 'no_surgery',
                                               'on_oab_medication_last_3_months', 'number_of_births', 'post_menopausal', 'prolapse_diagnosed',
                                               'hysterectomy', 'cesarean_section', 'surgery_for_benign_prostate_enlargement',
                                               'surgery_for_prostate_cancer', 'surgery_for_bladder_tumor', 'surgery_for_urethral_stricture',
                                               'surgery_for_urine_leakage', 'other_surgery', 'previous_surgery_details', 'recurrent_infections',
                                               'neurological_surgery_history', 'hypertension', 'hypothyroidism', 'high_cholesterol',
                                               'diabetes', 'back_problems', 'depression', 'other_psychiatric_conditions', 'reduced_immunity',
                                               'headaches', 'hip_osteoarthritis', 'knee_osteoarthritis', 'cancer_treatment_history',
                                               'cervical_cancer', 'endometrial_cancer', 'ovarian_cancer', 'breast_cancer', 'intestinal_cancer',
                                               'other_cancer', 'cancer_type_details', 'drug_allergies', 'drug_allergies_details',
                                               'glaucoma_or_eye_pressure_meds', 'cardiac_conditions', 'heart_attack', 'arrhythmia', 'stroke',
                                               'digestive_problems', 'dry_mucous_membranes', 'current_medications', 'current_medications_details',
                                               'past_medications', 'past_medications_details', 'completed']
                                  }
                                }
                              },
               required: ['anamnestic_forms', 'pagination']
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('create anamnestic_form') do
      let!(:iciq_form) { create(:iciq_form, patient: patient, completed: true) }
      let!(:ipss_form) do
        create(:ipss_form, patient: patient, completed: true, incomplete_emptying: 0, frequency: 0,
                           intermittent_urination: 0, urgency: 0, weak_stream: 0, straining: 0, nocturnal_urination: 1)
      end

      tags 'Anamnestic form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :anamnestic_form, in: :body, required: true, schema: {
        type: :object,
        properties: {
          anamnestic_form: {
            type: :object,
            properties: {
              age: { type: :integer },
              height: { type: :integer },
              weight: { type: :integer },
              on_oab_medication_last_3_months: { type: :boolean },
              number_of_births: { type: :integer },
              post_menopausal: { type: :boolean },
              prolapse_diagnosed: { type: :boolean },
              hysterectomy: { type: :boolean },
              cesarean_section: { type: :string, enum: ['true', 'false', 'no_birth'] },
              surgery_for_benign_prostate_enlargement: { type: :boolean },
              surgery_for_prostate_cancer: { type: :boolean },
              surgery_for_bladder_tumor: { type: :boolean },
              surgery_for_urethral_stricture: { type: :boolean },
              surgery_for_urine_leakage: { type: :boolean },
              no_surgery: { type: :boolean },
              other_surgery: { type: :boolean },
              previous_surgery_details: { type: :string },
              recurrent_infections: { type: :boolean },
              neurological_surgery_history: { type: :boolean },
              hypertension: { type: :boolean },
              hypothyroidism: { type: :boolean },
              high_cholesterol: { type: :boolean },
              diabetes: { type: :boolean },
              back_problems: { type: :boolean },
              depression: { type: :boolean },
              other_psychiatric_conditions: { type: :boolean },
              reduced_immunity: { type: :boolean },
              headaches: { type: :boolean },
              hip_osteoarthritis: { type: :boolean },
              knee_osteoarthritis: { type: :boolean },
              cancer_treatment_history: { type: :boolean },
              cervical_cancer: { type: :boolean },
              endometrial_cancer: { type: :boolean },
              ovarian_cancer: { type: :boolean },
              breast_cancer: { type: :boolean },
              intestinal_cancer: { type: :boolean },
              other_cancer: { type: :boolean },
              cancer_type_details: { type: :string },
              drug_allergies: { type: :boolean },
              drug_allergies_details: { type: :string },
              glaucoma_or_eye_pressure_meds: { type: :boolean },
              cardiac_conditions: { type: :boolean },
              heart_attack: { type: :boolean },
              arrhythmia: { type: :boolean },
              stroke: { type: :boolean },
              digestive_problems: { type: :boolean },
              dry_mucous_membranes: { type: :boolean },
              no_illness: { type: :boolean },
              current_medications: { type: :boolean },
              current_medications_details: { type: :string },
              past_medications: { type: :boolean },
              past_medications_details: { type: :string }
            },
            required: ['age', 'height', 'weight', 'on_oab_medication_last_3_months', 'recurrent_infections',
                       'hypertension', 'hypothyroidism', 'high_cholesterol',
                       'diabetes', 'back_problems', 'depression', 'other_psychiatric_conditions', 'reduced_immunity',
                       'headaches', 'hip_osteoarthritis', 'knee_osteoarthritis', 'cancer_treatment_history',
                       'drug_allergies', 'glaucoma_or_eye_pressure_meds', 'cardiac_conditions',
                       'heart_attack', 'arrhythmia', 'stroke', 'digestive_problems', 'dry_mucous_membranes',
                       'current_medications', 'past_medications']
          }
        },
        required: ['anamnestic_form']
      }
      let(:anamnestic_form) do
        {
          anamnestic_form: {
            completion_timestamp: '2024-12-24T12:00:00.000Z',
            age: 30,
            height: 175,
            weight: 70,
            on_oab_medication_last_3_months: false,
            number_of_births: 0,
            post_menopausal: false,
            prolapse_diagnosed: false,
            hysterectomy: false,
            cesarean_section: 'false',
            surgery_for_benign_prostate_enlargement: false,
            surgery_for_prostate_cancer: false,
            surgery_for_bladder_tumor: false,
            surgery_for_urethral_stricture: false,
            surgery_for_urine_leakage: false,
            other_surgery: false,
            previous_surgery_details: '',
            recurrent_infections: false,
            neurological_surgery_history: false,
            hypertension: false,
            hypothyroidism: false,
            high_cholesterol: false,
            diabetes: false,
            back_problems: false,
            depression: false,
            other_psychiatric_conditions: false,
            reduced_immunity: false,
            headaches: false,
            hip_osteoarthritis: false,
            knee_osteoarthritis: false,
            cancer_treatment_history: false,
            cervical_cancer: false,
            endometrial_cancer: false,
            ovarian_cancer: false,
            breast_cancer: false,
            intestinal_cancer: false,
            other_cancer: false,
            cancer_type_details: '',
            drug_allergies: false,
            drug_allergies_details: '',
            glaucoma_or_eye_pressure_meds: false,
            cardiac_conditions: false,
            heart_attack: false,
            arrhythmia: false,
            stroke: false,
            digestive_problems: false,
            dry_mucous_membranes: false,
            current_medications: false,
            current_medications_details: '',
            past_medications: false,
            past_medications_details: '',
            completed: true,
            patient_id: patient.id,
            no_surgery: true,
            no_illness: false
          }
        }
      end

      response(201, 'successful') do
        authorization_as_patient
        schema type: :object, properties: {
          anamnestic_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['anamnestic_form']
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(404, 'not found') do
        authorization_as_doctor
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(404, 'not found') do
        authorization_as_admin
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/anamnestic_forms/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    get('show anamnestic_form') do
      tags 'Anamnestic form'
      produces 'application/json'
      consumes 'multipart/json'
      security [Bearer: []]
      response(200, 'successful') do
        authorization_as_admin
        let(:id) { create(:anamnestic_form, patient: patient).id }
        schema type: :object, properties: {
                                anamnestic_form: {
                                  type: :object,
                                  properties: {
                                    completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                    age: { type: :integer },
                                    height: { type: :integer },
                                    weight: { type: :integer },
                                    on_oab_medication_last_3_months: { type: :boolean },
                                    number_of_births: { type: :integer },
                                    post_menopausal: { type: :boolean },
                                    prolapse_diagnosed: { type: :boolean },
                                    hysterectomy: { type: :boolean },
                                    cesarean_section: { type: :string, enum: ['true', 'false', 'no_birth'] },
                                    surgery_for_benign_prostate_enlargement: { type: :boolean },
                                    surgery_for_prostate_cancer: { type: :boolean },
                                    surgery_for_bladder_tumor: { type: :boolean },
                                    surgery_for_urethral_stricture: { type: :boolean },
                                    surgery_for_urine_leakage: { type: :boolean },
                                    no_surgery: { type: :boolean },
                                    other_surgery: { type: :boolean },
                                    previous_surgery_details: { type: :string },
                                    recurrent_infections: { type: :boolean },
                                    neurological_surgery_history: { type: :boolean },
                                    hypertension: { type: :boolean },
                                    hypothyroidism: { type: :boolean },
                                    high_cholesterol: { type: :boolean },
                                    diabetes: { type: :boolean },
                                    back_problems: { type: :boolean },
                                    depression: { type: :boolean },
                                    other_psychiatric_conditions: { type: :boolean },
                                    reduced_immunity: { type: :boolean },
                                    headaches: { type: :boolean },
                                    hip_osteoarthritis: { type: :boolean },
                                    knee_osteoarthritis: { type: :boolean },
                                    cancer_treatment_history: { type: :boolean },
                                    cervical_cancer: { type: :boolean },
                                    endometrial_cancer: { type: :boolean },
                                    ovarian_cancer: { type: :boolean },
                                    breast_cancer: { type: :boolean },
                                    intestinal_cancer: { type: :boolean },
                                    other_cancer: { type: :boolean },
                                    cancer_type_details: { type: :string },
                                    drug_allergies: { type: :boolean },
                                    drug_allergies_details: { type: :string },
                                    glaucoma_or_eye_pressure_meds: { type: :boolean },
                                    cardiac_conditions: { type: :boolean },
                                    heart_attack: { type: :boolean },
                                    arrhythmia: { type: :boolean },
                                    stroke: { type: :boolean },
                                    digestive_problems: { type: :boolean },
                                    dry_mucous_membranes: { type: :boolean },
                                    no_illness: { type: :boolean },
                                    current_medications: { type: :boolean },
                                    current_medications_details: { type: :string },
                                    past_medications: { type: :boolean },
                                    past_medications_details: { type: :string },
                                    completed: { type: :boolean },
                                    id: { type: :integer },
                                    patient_public_id: { type: :string },
                                    patient_id: { type: :integer },
                                    gender: { type: :string, enum: ['male', 'female'] }
                                  },
                                  required: ['id', 'completion_timestamp', 'age', 'height', 'weight', 'patient_id', 'patient_public_id',
                                             'on_oab_medication_last_3_months', 'number_of_births', 'post_menopausal', 'prolapse_diagnosed',
                                             'hysterectomy', 'cesarean_section', 'surgery_for_benign_prostate_enlargement',
                                             'surgery_for_prostate_cancer', 'surgery_for_bladder_tumor', 'surgery_for_urethral_stricture',
                                             'surgery_for_urine_leakage', 'other_surgery', 'previous_surgery_details', 'recurrent_infections',
                                             'neurological_surgery_history', 'hypertension', 'hypothyroidism', 'high_cholesterol',
                                             'diabetes', 'back_problems', 'depression', 'other_psychiatric_conditions', 'reduced_immunity',
                                             'headaches', 'hip_osteoarthritis', 'knee_osteoarthritis', 'cancer_treatment_history',
                                             'cervical_cancer', 'endometrial_cancer', 'ovarian_cancer', 'breast_cancer', 'intestinal_cancer',
                                             'other_cancer', 'cancer_type_details', 'drug_allergies', 'drug_allergies_details',
                                             'glaucoma_or_eye_pressure_meds', 'cardiac_conditions', 'heart_attack', 'arrhythmia', 'stroke',
                                             'digestive_problems', 'dry_mucous_membranes', 'current_medications', 'current_medications_details',
                                             'past_medications', 'past_medications_details', 'completed', 'gender', 'no_illness', 'no_surgery']
                                }
                              },
               required: ['anamnestic_form']
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(200, 'successful') do
        authorization_as_patient
        let(:id) { create(:anamnestic_form, patient: patient).id }
        schema type: :object, properties: {
                                anamnestic_form: {
                                  type: :object,
                                  properties: {
                                    completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                    age: { type: :integer },
                                    height: { type: :integer },
                                    weight: { type: :integer },
                                    on_oab_medication_last_3_months: { type: :boolean },
                                    number_of_births: { type: :integer },
                                    post_menopausal: { type: :boolean },
                                    prolapse_diagnosed: { type: :boolean },
                                    hysterectomy: { type: :boolean },
                                    cesarean_section: { type: :string, enum: ['true', 'false', 'no_birth'] },
                                    surgery_for_benign_prostate_enlargement: { type: :boolean },
                                    surgery_for_prostate_cancer: { type: :boolean },
                                    surgery_for_bladder_tumor: { type: :boolean },
                                    surgery_for_urethral_stricture: { type: :boolean },
                                    surgery_for_urine_leakage: { type: :boolean },
                                    no_surgery: { type: :boolean },
                                    other_surgery: { type: :boolean },
                                    previous_surgery_details: { type: :string },
                                    recurrent_infections: { type: :boolean },
                                    neurological_surgery_history: { type: :boolean },
                                    hypertension: { type: :boolean },
                                    hypothyroidism: { type: :boolean },
                                    high_cholesterol: { type: :boolean },
                                    diabetes: { type: :boolean },
                                    back_problems: { type: :boolean },
                                    depression: { type: :boolean },
                                    other_psychiatric_conditions: { type: :boolean },
                                    reduced_immunity: { type: :boolean },
                                    headaches: { type: :boolean },
                                    hip_osteoarthritis: { type: :boolean },
                                    knee_osteoarthritis: { type: :boolean },
                                    cancer_treatment_history: { type: :boolean },
                                    cervical_cancer: { type: :boolean },
                                    endometrial_cancer: { type: :boolean },
                                    ovarian_cancer: { type: :boolean },
                                    breast_cancer: { type: :boolean },
                                    intestinal_cancer: { type: :boolean },
                                    other_cancer: { type: :boolean },
                                    cancer_type_details: { type: :string },
                                    drug_allergies: { type: :boolean },
                                    drug_allergies_details: { type: :string },
                                    glaucoma_or_eye_pressure_meds: { type: :boolean },
                                    cardiac_conditions: { type: :boolean },
                                    heart_attack: { type: :boolean },
                                    arrhythmia: { type: :boolean },
                                    stroke: { type: :boolean },
                                    digestive_problems: { type: :boolean },
                                    dry_mucous_membranes: { type: :boolean },
                                    no_illness: { type: :boolean },
                                    current_medications: { type: :boolean },
                                    current_medications_details: { type: :string },
                                    past_medications: { type: :boolean },
                                    past_medications_details: { type: :string },
                                    completed: { type: :boolean },
                                    id: { type: :integer },
                                    patient_public_id: { type: :string },
                                    patient_id: { type: :integer },
                                    gender: { type: :string, enum: ['male', 'female'] }
                                  },
                                  required: ['id', 'completion_timestamp', 'age', 'height', 'weight', 'patient_id', 'patient_public_id',
                                             'on_oab_medication_last_3_months', 'number_of_births', 'post_menopausal', 'prolapse_diagnosed',
                                             'hysterectomy', 'cesarean_section', 'surgery_for_benign_prostate_enlargement',
                                             'surgery_for_prostate_cancer', 'surgery_for_bladder_tumor', 'surgery_for_urethral_stricture',
                                             'surgery_for_urine_leakage', 'other_surgery', 'previous_surgery_details', 'recurrent_infections',
                                             'neurological_surgery_history', 'hypertension', 'hypothyroidism', 'high_cholesterol',
                                             'diabetes', 'back_problems', 'depression', 'other_psychiatric_conditions', 'reduced_immunity',
                                             'headaches', 'hip_osteoarthritis', 'knee_osteoarthritis', 'cancer_treatment_history',
                                             'cervical_cancer', 'endometrial_cancer', 'ovarian_cancer', 'breast_cancer', 'intestinal_cancer',
                                             'other_cancer', 'cancer_type_details', 'drug_allergies', 'drug_allergies_details',
                                             'glaucoma_or_eye_pressure_meds', 'cardiac_conditions', 'heart_attack', 'arrhythmia', 'stroke',
                                             'digestive_problems', 'dry_mucous_membranes', 'current_medications', 'current_medications_details',
                                             'past_medications', 'past_medications_details', 'completed', 'gender', 'no_illness', 'no_surgery']
                                }
                              },
               required: ['anamnestic_form']
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(200, 'successful') do
        authorization_as_doctor
        let(:id) { create(:anamnestic_form, patient: patient).id }
        schema type: :object, properties: {
                                anamnestic_form: {
                                  type: :object,
                                  properties: {
                                    completion_timestamp: { type: :string, format: 'date-time', nullable: true },
                                    age: { type: :integer },
                                    height: { type: :integer },
                                    weight: { type: :integer },
                                    on_oab_medication_last_3_months: { type: :boolean },
                                    number_of_births: { type: :integer },
                                    post_menopausal: { type: :boolean },
                                    prolapse_diagnosed: { type: :boolean },
                                    hysterectomy: { type: :boolean },
                                    cesarean_section: { type: :string, enum: ['true', 'false', 'no_birth'] },
                                    surgery_for_benign_prostate_enlargement: { type: :boolean },
                                    surgery_for_prostate_cancer: { type: :boolean },
                                    surgery_for_bladder_tumor: { type: :boolean },
                                    surgery_for_urethral_stricture: { type: :boolean },
                                    surgery_for_urine_leakage: { type: :boolean },
                                    no_surgery: { type: :boolean },
                                    other_surgery: { type: :boolean },
                                    previous_surgery_details: { type: :string },
                                    recurrent_infections: { type: :boolean },
                                    neurological_surgery_history: { type: :boolean },
                                    hypertension: { type: :boolean },
                                    hypothyroidism: { type: :boolean },
                                    high_cholesterol: { type: :boolean },
                                    diabetes: { type: :boolean },
                                    back_problems: { type: :boolean },
                                    depression: { type: :boolean },
                                    other_psychiatric_conditions: { type: :boolean },
                                    reduced_immunity: { type: :boolean },
                                    headaches: { type: :boolean },
                                    hip_osteoarthritis: { type: :boolean },
                                    knee_osteoarthritis: { type: :boolean },
                                    cancer_treatment_history: { type: :boolean },
                                    cervical_cancer: { type: :boolean },
                                    endometrial_cancer: { type: :boolean },
                                    ovarian_cancer: { type: :boolean },
                                    breast_cancer: { type: :boolean },
                                    intestinal_cancer: { type: :boolean },
                                    other_cancer: { type: :boolean },
                                    cancer_type_details: { type: :string },
                                    drug_allergies: { type: :boolean },
                                    drug_allergies_details: { type: :string },
                                    glaucoma_or_eye_pressure_meds: { type: :boolean },
                                    cardiac_conditions: { type: :boolean },
                                    heart_attack: { type: :boolean },
                                    arrhythmia: { type: :boolean },
                                    stroke: { type: :boolean },
                                    digestive_problems: { type: :boolean },
                                    dry_mucous_membranes: { type: :boolean },
                                    no_illness: { type: :boolean },
                                    current_medications: { type: :boolean },
                                    current_medications_details: { type: :string },
                                    past_medications: { type: :boolean },
                                    past_medications_details: { type: :string },
                                    completed: { type: :boolean },
                                    id: { type: :integer },
                                    patient_public_id: { type: :string },
                                    patient_id: { type: :integer },
                                    gender: { type: :string, enum: ['male', 'female'] }
                                  },
                                  required: ['id', 'completion_timestamp', 'age', 'height', 'weight', 'patient_id', 'patient_public_id',
                                             'on_oab_medication_last_3_months', 'number_of_births', 'post_menopausal', 'prolapse_diagnosed',
                                             'hysterectomy', 'cesarean_section', 'surgery_for_benign_prostate_enlargement',
                                             'surgery_for_prostate_cancer', 'surgery_for_bladder_tumor', 'surgery_for_urethral_stricture',
                                             'surgery_for_urine_leakage', 'other_surgery', 'previous_surgery_details', 'recurrent_infections',
                                             'neurological_surgery_history', 'hypertension', 'hypothyroidism', 'high_cholesterol',
                                             'diabetes', 'back_problems', 'depression', 'other_psychiatric_conditions', 'reduced_immunity',
                                             'headaches', 'hip_osteoarthritis', 'knee_osteoarthritis', 'cancer_treatment_history',
                                             'cervical_cancer', 'endometrial_cancer', 'ovarian_cancer', 'breast_cancer', 'intestinal_cancer',
                                             'other_cancer', 'cancer_type_details', 'drug_allergies', 'drug_allergies_details',
                                             'glaucoma_or_eye_pressure_meds', 'cardiac_conditions', 'heart_attack', 'arrhythmia', 'stroke',
                                             'digestive_problems', 'dry_mucous_membranes', 'current_medications', 'current_medications_details',
                                             'past_medications', 'past_medications_details', 'completed', 'gender', 'no_illness', 'no_surgery']
                                }
                              },
               required: ['anamnestic_form']
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    put('update anamnestic_form') do
      tags 'Anamnestic form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      parameter name: :anamnestic_form, in: :body, required: true, schema: {
        type: :object,
        properties: {
          anamnestic_form: {
            type: :object,
            properties: {
              age: { type: :integer },
              height: { type: :integer },
              weight: { type: :integer },
              on_oab_medication_last_3_months: { type: :boolean },
              number_of_births: { type: :integer },
              post_menopausal: { type: :boolean },
              prolapse_diagnosed: { type: :boolean },
              hysterectomy: { type: :boolean },
              cesarean_section: { type: :string, enum: ['true', 'false', 'no_birth'] },
              surgery_for_benign_prostate_enlargement: { type: :boolean },
              surgery_for_prostate_cancer: { type: :boolean },
              surgery_for_bladder_tumor: { type: :boolean },
              surgery_for_urethral_stricture: { type: :boolean },
              surgery_for_urine_leakage: { type: :boolean },
              other_surgery: { type: :boolean },
              previous_surgery_details: { type: :string },
              recurrent_infections: { type: :boolean },
              neurological_surgery_history: { type: :boolean },
              hypertension: { type: :boolean },
              hypothyroidism: { type: :boolean },
              high_cholesterol: { type: :boolean },
              diabetes: { type: :boolean },
              back_problems: { type: :boolean },
              depression: { type: :boolean },
              other_psychiatric_conditions: { type: :boolean },
              reduced_immunity: { type: :boolean },
              headaches: { type: :boolean },
              hip_osteoarthritis: { type: :boolean },
              knee_osteoarthritis: { type: :boolean },
              cancer_treatment_history: { type: :boolean },
              cervical_cancer: { type: :boolean },
              endometrial_cancer: { type: :boolean },
              ovarian_cancer: { type: :boolean },
              breast_cancer: { type: :boolean },
              intestinal_cancer: { type: :boolean },
              other_cancer: { type: :boolean },
              cancer_type_details: { type: :string },
              drug_allergies: { type: :boolean },
              drug_allergies_details: { type: :string },
              glaucoma_or_eye_pressure_meds: { type: :boolean },
              cardiac_conditions: { type: :boolean },
              heart_attack: { type: :boolean },
              arrhythmia: { type: :boolean },
              stroke: { type: :boolean },
              digestive_problems: { type: :boolean },
              dry_mucous_membranes: { type: :boolean },
              current_medications: { type: :boolean },
              current_medications_details: { type: :string },
              past_medications: { type: :boolean },
              past_medications_details: { type: :string },
              no_illness: { type: :boolean },
              no_surgery: { type: :boolean }
            }
          }
        },
        required: ['anamnestic_form']
      }
      let(:id) { create(:anamnestic_form, patient: patient).id }
      let(:anamnestic_form) do
        {
          anamnestic_form: {
            age: 40,
            height: 180
          }
        }
      end
      response(200, 'successful') do
        authorization_as_admin
        schema type: :object, properties: {
          anamnestic_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['anamnestic_form']
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(200, 'successful') do
        authorization_as_patient
        schema type: :object, properties: {
          anamnestic_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['anamnestic_form']
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(200, 'successful') do
        authorization_as_doctor
        schema type: :object, properties: {
          anamnestic_form: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 }
            },
            required: ['id']
          }
        }, required: ['anamnestic_form']
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    delete('delete anamnestic_form') do
      tags 'Anamnestic form'
      produces 'application/json'
      consumes 'application/json'
      security [Bearer: []]
      let(:id) { create(:anamnestic_form, patient: patient).id }
      response(204, 'successful') do
        authorization_as_admin
        run_test!
      end

      response(404, 'not found') do
        authorization_as_patient
        run_test!
      end

      response(404, 'not found') do
        authorization_as_doctor
        run_test!
      end
    end
  end
end
