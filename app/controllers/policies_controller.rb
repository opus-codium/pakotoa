# frozen_string_literal: true

class PoliciesController < ApplicationController
  def index
    @policies = Policy.all
  end

  def new
    @policy = Policy.new
  end

  def create
    @policy = Policy.new(policy_params)
    if @policy.save
      redirect_to @policy, notice: "Policy was successfully created."
    else
      render "new", status: :unprocessable_content
    end
  end

  def show
    @policy = Policy.find(params[:id])
    redirect_to policy_subject_attributes_path(@policy)
  end

  def edit
    @policy = Policy.find(params[:id])
  end

  def update
    @policy = Policy.find(params[:id])
    if @policy.update(policy_params)
      redirect_to @policy, notice: "Policy was successfully updated."
    else
      render "edit", status: :unprocessable_content
    end
  end

  def destroy
    @policy = Policy.find(params[:id])
    if @policy.destroy
      redirect_to policies_path, notice: "Policy was successfully removed."
    else
      redirect_to policies_path, alert: "Cannot remove policy."
    end
  end

  private

  def policy_params
    params.require("policy").permit("name")
  end
end
