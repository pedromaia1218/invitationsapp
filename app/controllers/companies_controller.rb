# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_company, only: [:edit, :update, :destroy]

  def index
    result = UseCases::Companies::ListCompanies.call(
      page: params[:page],
      per_page: params[:per_page]
    )

    @companies = result[:companies]
  end

  def new
    @company = Company.new
  end

  def create
    UseCases::Companies::CreateCompany
      .call(params: company_params)
      .on_success { |result| redirect_to companies_path, notice: 'Empresa criada com sucesso.' }
      .on_failure { |result|
        @company = Company.new(company_params)
        @errors = result[:errors]
        render :new, status: :unprocessable_entity
      }
  end

  def edit
  end

  def update
    UseCases::Companies::UpdateCompany
      .call(company: @company, params: company_params)
      .on_success { |result| redirect_to companies_path, notice: 'Empresa atualizada com sucesso.' }
      .on_failure { |result| @errors = result[:errors]; render :edit, status: :unprocessable_entity }
  end

  def destroy
    UseCases::Companies::DeleteCompany
      .call(company: @company)
      .on_success { |result| redirect_to companies_path, notice: 'Empresa excluída com sucesso.' }
      .on_failure { |result| redirect_to companies_path, alert: result[:errors].first }
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :cnpj, :address, :active)
  end
end
