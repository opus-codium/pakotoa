# frozen_string_literal: true

class SubjectAttributesController < ApplicationController
  before_action do
    @policy = Policy.find(params[:policy_id])
  end

  add_breadcrumb "policies.index.title", "policies_path"
  add_breadcrumb :policy_title, "policy_path(@policy)", except: :index

  # GET /attributes
  def index
    @subject_attributes = @policy.subject_attributes.order("position")
  end

  # GET /attributes/1
  def show
    @subject_attribute = @policy.subject_attributes.find(params[:id])
  end

  # GET /attributes/new
  def new
    @subject_attribute = @policy.subject_attributes.new
  end

  # GET /attributes/1/edit
  def edit
    @subject_attribute = @policy.subject_attributes.find(params[:id])
  end

  # POST /attributes
  def create
    @subject_attribute = @policy.subject_attributes.new(subject_attribute_params)
    if @subject_attribute.save
      redirect_to [@policy, @subject_attribute], notice: "Subject attribute was successfully created."
    else
      render "new", status: :unprocessable_entity
    end
  end

  # PATCH/PUT /attributes/1
  def update
    @subject_attribute = @policy.subject_attributes.find(params[:id])
    if @subject_attribute.update(subject_attribute_params)
      redirect_to [@policy, @subject_attribute], notice: "Subject attribute was successfully updated."
    else
      render "edit", status: :unprocessable_entity
    end
  end

  # DELETE /attributes/1
  def destroy
    @subject_attribute = @policy.subject_attributes.find(params[:id])
    @subject_attribute.destroy
    redirect_to policy_subject_attributes_path(@policy), notice: "Subject attribute was successfully removed."
  end

  def move
    @subject_attribute = @policy.subject_attributes.find(params[:id])
    @subject_attribute.insert_at(params[:position].to_i)
    head :ok
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_attribute_params
      params.require(:subject_attribute).permit(:oid_id, :description, :default, :min, :max, :strategy)
    end
end
