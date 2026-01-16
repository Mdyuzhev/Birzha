<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { resumesApi } from '@/api/resumes'
import { employeesApi } from '@/api/employees'
import { ElMessage } from 'element-plus'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

const resumes = ref([])
const employees = ref([])
const loading = ref(false)
const searchQuery = ref('')
const selectedResume = ref(null)
const dialogVisible = ref(false)
const editMode = ref(false)
const viewDialogVisible = ref(false)
const viewingResume = ref(null)

// Form data
const form = ref({
  employeeId: null,
  position: '',
  summary: '',
  skills: [],
  experience: [],
  education: [],
  certifications: [],
  languages: []
})

// Temp data for adding items
const newSkill = ref({ name: '', level: 'Средний', years: '' })
const newExperience = ref({ company: '', position: '', startDate: '', endDate: '', description: '', projects: [] })
const newEducation = ref({ institution: '', degree: '', field: '', year: '' })
const newCertification = ref({ name: '', issuer: '', year: '' })
const newLanguage = ref({ language: '', level: 'Базовый' })
const newProject = ref({ name: '', description: '' })

const skillLevels = ['Начинающий', 'Базовый', 'Средний', 'Продвинутый', 'Эксперт']
const languageLevels = ['Начальный (A1)', 'Элементарный (A2)', 'Средний (B1)', 'Выше среднего (B2)', 'Продвинутый (C1)', 'Свободный (C2)', 'Родной']

onMounted(async () => {
  await fetchResumes()
  fetchEmployees()

  // Открыть резюме если есть параметр view
  if (route.query.view) {
    const resumeId = parseInt(route.query.view)
    const resume = resumes.value.find(r => r.id === resumeId)
    if (resume) {
      openViewDialog(resume)
    }
  }
})

// Следить за изменением query параметра
watch(() => route.query.view, async (newViewId) => {
  if (newViewId) {
    const resumeId = parseInt(newViewId)
    let resume = resumes.value.find(r => r.id === resumeId)
    if (!resume) {
      try {
        const response = await resumesApi.getById(resumeId)
        resume = response.data
      } catch (error) {
        console.error('Error fetching resume:', error)
        return
      }
    }
    if (resume) {
      openViewDialog(resume)
    }
  }
})

async function fetchResumes() {
  loading.value = true
  try {
    const response = await resumesApi.getAll(searchQuery.value)
    resumes.value = response.data
  } catch (error) {
    console.error('Error fetching resumes:', error)
  } finally {
    loading.value = false
  }
}

async function fetchEmployees() {
  try {
    const response = await employeesApi.getAll({ size: 1000 })
    employees.value = response.data.content || response.data
  } catch (error) {
    console.error('Error fetching employees:', error)
  }
}

function handleSearch() {
  fetchResumes()
}

function openCreateDialog() {
  editMode.value = false
  resetForm()
  dialogVisible.value = true
}

function openViewDialog(resume) {
  viewingResume.value = resume
  viewDialogVisible.value = true
}

function openEditDialog(resume) {
  editMode.value = true
  selectedResume.value = resume
  form.value = {
    employeeId: resume.employeeId,
    position: resume.position || '',
    summary: resume.summary || '',
    skills: resume.skills ? [...resume.skills] : [],
    experience: resume.experience ? [...resume.experience] : [],
    education: resume.education ? [...resume.education] : [],
    certifications: resume.certifications ? [...resume.certifications] : [],
    languages: resume.languages ? [...resume.languages] : []
  }
  dialogVisible.value = true
}

function resetForm() {
  form.value = {
    employeeId: null,
    position: '',
    summary: '',
    skills: [],
    experience: [],
    education: [],
    certifications: [],
    languages: []
  }
  selectedResume.value = null
}

async function saveResume() {
  if (!form.value.employeeId) {
    ElMessage.warning('Выберите сотрудника')
    return
  }

  try {
    await resumesApi.create(form.value)
    ElMessage.success(editMode.value ? 'Резюме обновлено' : 'Резюме создано')
    dialogVisible.value = false
    fetchResumes()
  } catch (error) {
    ElMessage.error('Ошибка сохранения резюме')
  }
}

async function deleteResume(resume) {
  try {
    await resumesApi.delete(resume.id)
    ElMessage.success('Резюме удалено')
    fetchResumes()
  } catch (error) {
    ElMessage.error('Ошибка удаления')
  }
}

async function exportPdf(resume) {
  try {
    const response = await resumesApi.exportPdf(resume.id)
    const blob = new Blob([response.data], { type: 'application/pdf' })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `${resume.employeeName.replace(/[^a-zA-Zа-яА-Я0-9]/g, '_')}_resume.pdf`
    link.click()
    window.URL.revokeObjectURL(url)
  } catch (error) {
    ElMessage.error('Ошибка экспорта PDF')
  }
}

// Skills
function addSkill() {
  if (newSkill.value.name) {
    form.value.skills.push({ ...newSkill.value })
    newSkill.value = { name: '', level: 'Средний', years: '' }
  }
}

function removeSkill(index) {
  form.value.skills.splice(index, 1)
}

// Experience
function addExperience() {
  if (newExperience.value.company && newExperience.value.position) {
    form.value.experience.push({ ...newExperience.value, projects: [...newExperience.value.projects] })
    newExperience.value = { company: '', position: '', startDate: '', endDate: '', description: '', projects: [] }
  }
}

function removeExperience(index) {
  form.value.experience.splice(index, 1)
}

function addProject() {
  if (newProject.value.name) {
    newExperience.value.projects.push({ ...newProject.value })
    newProject.value = { name: '', description: '' }
  }
}

function removeProject(index) {
  newExperience.value.projects.splice(index, 1)
}

// Education
function addEducation() {
  if (newEducation.value.institution) {
    form.value.education.push({ ...newEducation.value })
    newEducation.value = { institution: '', degree: '', field: '', year: '' }
  }
}

function removeEducation(index) {
  form.value.education.splice(index, 1)
}

// Certifications
function addCertification() {
  if (newCertification.value.name) {
    form.value.certifications.push({ ...newCertification.value })
    newCertification.value = { name: '', issuer: '', year: '' }
  }
}

function removeCertification(index) {
  form.value.certifications.splice(index, 1)
}

// Languages
function addLanguage() {
  if (newLanguage.value.language) {
    form.value.languages.push({ ...newLanguage.value })
    newLanguage.value = { language: '', level: 'Базовый' }
  }
}

function removeLanguage(index) {
  form.value.languages.splice(index, 1)
}

function goBack() {
  router.push('/')
}

// Employees without resume
const employeesWithoutResume = computed(() => {
  const resumeEmployeeIds = resumes.value.map(r => r.employeeId)
  return employees.value.filter(e => !resumeEmployeeIds.includes(e.id))
})
</script>

<template>
  <div class="resumes-container">
    <!-- Header -->
    <div class="page-header glass-card">
      <div class="header-left">
        <el-button class="btn-back" @click="goBack">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
            <path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/>
          </svg>
          <span>Назад</span>
        </el-button>
        <h1 class="page-title">
          <svg viewBox="0 0 24 24" fill="currentColor" width="28" height="28">
            <path d="M14 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/>
          </svg>
          Проектные резюме
        </h1>
      </div>
      <div class="header-right">
        <el-input
          v-model="searchQuery"
          placeholder="Поиск по ФИО..."
          class="search-input"
          clearable
          @keyup.enter="handleSearch"
          @clear="handleSearch"
        >
          <template #prefix>
            <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
              <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
            </svg>
          </template>
        </el-input>
        <el-button type="primary" @click="handleSearch">Найти</el-button>
        <el-button type="success" @click="openCreateDialog">
          <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18" style="margin-right: 6px;">
            <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
          </svg>
          Создать резюме
        </el-button>
      </div>
    </div>

    <!-- Resumes Grid -->
    <div class="resumes-grid" v-loading="loading">
      <div v-if="resumes.length === 0 && !loading" class="empty-state">
        <svg viewBox="0 0 24 24" fill="currentColor" width="64" height="64">
          <path d="M14 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V8l-6-6zm4 18H6V4h7v5h5v11z"/>
        </svg>
        <p>Резюме не найдены</p>
        <el-button type="primary" @click="openCreateDialog">Создать первое резюме</el-button>
      </div>

      <div v-for="resume in resumes" :key="resume.id" class="resume-card glass-card" @click="openViewDialog(resume)">
        <div class="resume-header">
          <div class="avatar">
            {{ resume.employeeName?.charAt(0) || '?' }}
          </div>
          <div class="info">
            <h3>{{ resume.employeeName }}</h3>
            <p class="position">{{ resume.position || 'Должность не указана' }}</p>
            <p class="email">{{ resume.employeeEmail }}</p>
          </div>
        </div>

        <div class="resume-summary" v-if="resume.summary">
          <p>{{ resume.summary.substring(0, 150) }}{{ resume.summary.length > 150 ? '...' : '' }}</p>
        </div>

        <div class="resume-skills" v-if="resume.skills?.length">
          <div class="skills-list">
            <span v-for="(skill, idx) in resume.skills.slice(0, 5)" :key="idx" class="skill-tag">
              {{ skill.name }}
            </span>
            <span v-if="resume.skills.length > 5" class="skill-more">+{{ resume.skills.length - 5 }}</span>
          </div>
        </div>

        <div class="resume-actions" @click.stop>
          <el-button size="small" @click="openEditDialog(resume)">
            <svg viewBox="0 0 24 24" fill="currentColor" width="14" height="14">
              <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
            </svg>
            Редактировать
          </el-button>
          <el-button size="small" type="primary" @click="exportPdf(resume)">
            <svg viewBox="0 0 24 24" fill="currentColor" width="14" height="14">
              <path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/>
            </svg>
            PDF
          </el-button>
          <el-button size="small" type="danger" @click="deleteResume(resume)">
            <svg viewBox="0 0 24 24" fill="currentColor" width="14" height="14">
              <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
            </svg>
          </el-button>
        </div>
      </div>
    </div>

    <!-- Create/Edit Dialog -->
    <el-dialog
      v-model="dialogVisible"
      :title="editMode ? 'Редактирование резюме' : 'Создание резюме'"
      width="900px"
      class="resume-dialog"
      destroy-on-close
    >
      <el-form :model="form" label-position="top">
        <!-- Employee Selection -->
        <el-form-item label="Сотрудник" required>
          <el-select
            v-model="form.employeeId"
            placeholder="Выберите сотрудника"
            filterable
            style="width: 100%"
            :disabled="editMode"
          >
            <el-option
              v-for="emp in (editMode ? employees : employeesWithoutResume)"
              :key="emp.id"
              :label="emp.fullName"
              :value="emp.id"
            />
          </el-select>
        </el-form-item>

        <el-form-item label="Желаемая должность">
          <el-input v-model="form.position" placeholder="Java Developer, Project Manager..." />
        </el-form-item>

        <el-form-item label="О себе">
          <el-input
            v-model="form.summary"
            type="textarea"
            :rows="4"
            placeholder="Краткое описание опыта и компетенций..."
          />
        </el-form-item>

        <!-- Skills -->
        <el-divider>Ключевые навыки</el-divider>
        <div class="form-section">
          <div class="add-row">
            <el-input v-model="newSkill.name" placeholder="Навык" style="width: 200px" />
            <el-select v-model="newSkill.level" style="width: 150px">
              <el-option v-for="l in skillLevels" :key="l" :label="l" :value="l" />
            </el-select>
            <el-input v-model="newSkill.years" placeholder="Лет опыта" style="width: 100px" />
            <el-button type="primary" @click="addSkill">Добавить</el-button>
          </div>
          <div class="items-list">
            <el-tag v-for="(skill, idx) in form.skills" :key="idx" closable @close="removeSkill(idx)">
              {{ skill.name }} ({{ skill.level }}, {{ skill.years }} лет)
            </el-tag>
          </div>
        </div>

        <!-- Experience -->
        <el-divider>Опыт работы</el-divider>
        <div class="form-section">
          <div class="add-row">
            <el-input v-model="newExperience.company" placeholder="Компания" style="width: 180px" />
            <el-input v-model="newExperience.position" placeholder="Должность" style="width: 180px" />
            <el-input v-model="newExperience.startDate" placeholder="Начало (2020-01)" style="width: 120px" />
            <el-input v-model="newExperience.endDate" placeholder="Окончание" style="width: 120px" />
          </div>
          <el-input
            v-model="newExperience.description"
            type="textarea"
            :rows="2"
            placeholder="Описание обязанностей..."
            style="margin-top: 10px"
          />
          <div class="projects-section">
            <span>Проекты:</span>
            <div class="add-row" style="margin-top: 5px">
              <el-input v-model="newProject.name" placeholder="Название проекта" style="width: 200px" />
              <el-input v-model="newProject.description" placeholder="Описание" style="width: 300px" />
              <el-button size="small" @click="addProject">+</el-button>
            </div>
            <div class="items-list" v-if="newExperience.projects.length">
              <el-tag v-for="(proj, idx) in newExperience.projects" :key="idx" closable @close="removeProject(idx)">
                {{ proj.name }}
              </el-tag>
            </div>
          </div>
          <el-button type="primary" @click="addExperience" style="margin-top: 10px">Добавить опыт</el-button>

          <div class="experience-list">
            <div v-for="(exp, idx) in form.experience" :key="idx" class="experience-item">
              <div class="exp-header">
                <strong>{{ exp.company }}</strong> - {{ exp.position }}
                <span class="exp-dates">{{ exp.startDate }} - {{ exp.endDate || 'по н.в.' }}</span>
                <el-button type="danger" size="small" @click="removeExperience(idx)">Удалить</el-button>
              </div>
              <p v-if="exp.description">{{ exp.description }}</p>
              <div v-if="exp.projects?.length" class="exp-projects">
                <span>Проекты: </span>
                <el-tag v-for="(p, i) in exp.projects" :key="i" size="small">{{ p.name }}</el-tag>
              </div>
            </div>
          </div>
        </div>

        <!-- Education -->
        <el-divider>Образование</el-divider>
        <div class="form-section">
          <div class="add-row">
            <el-input v-model="newEducation.institution" placeholder="Учебное заведение" style="width: 250px" />
            <el-input v-model="newEducation.degree" placeholder="Степень" style="width: 150px" />
            <el-input v-model="newEducation.field" placeholder="Специальность" style="width: 200px" />
            <el-input v-model="newEducation.year" placeholder="Год" style="width: 80px" />
            <el-button type="primary" @click="addEducation">Добавить</el-button>
          </div>
          <div class="items-list">
            <div v-for="(edu, idx) in form.education" :key="idx" class="edu-item">
              <span>{{ edu.institution }}, {{ edu.degree }} - {{ edu.field }} ({{ edu.year }})</span>
              <el-button type="danger" size="small" @click="removeEducation(idx)">Удалить</el-button>
            </div>
          </div>
        </div>

        <!-- Certifications -->
        <el-divider>Сертификаты</el-divider>
        <div class="form-section">
          <div class="add-row">
            <el-input v-model="newCertification.name" placeholder="Название сертификата" style="width: 250px" />
            <el-input v-model="newCertification.issuer" placeholder="Организация" style="width: 200px" />
            <el-input v-model="newCertification.year" placeholder="Год" style="width: 80px" />
            <el-button type="primary" @click="addCertification">Добавить</el-button>
          </div>
          <div class="items-list">
            <el-tag v-for="(cert, idx) in form.certifications" :key="idx" closable @close="removeCertification(idx)">
              {{ cert.name }} ({{ cert.issuer }}, {{ cert.year }})
            </el-tag>
          </div>
        </div>

        <!-- Languages -->
        <el-divider>Языки</el-divider>
        <div class="form-section">
          <div class="add-row">
            <el-input v-model="newLanguage.language" placeholder="Язык" style="width: 150px" />
            <el-select v-model="newLanguage.level" style="width: 200px">
              <el-option v-for="l in languageLevels" :key="l" :label="l" :value="l" />
            </el-select>
            <el-button type="primary" @click="addLanguage">Добавить</el-button>
          </div>
          <div class="items-list">
            <el-tag v-for="(lang, idx) in form.languages" :key="idx" closable @close="removeLanguage(idx)">
              {{ lang.language }} - {{ lang.level }}
            </el-tag>
          </div>
        </div>
      </el-form>

      <template #footer>
        <el-button @click="dialogVisible = false">Отмена</el-button>
        <el-button type="primary" @click="saveResume">Сохранить</el-button>
      </template>
    </el-dialog>

    <!-- View Dialog -->
    <el-dialog
      v-model="viewDialogVisible"
      :title="viewingResume?.employeeName || 'Просмотр резюме'"
      width="800px"
      custom-class="resume-view-dialog"
      destroy-on-close
    >
      <div v-if="viewingResume" class="resume-view">
        <!-- Header -->
        <div class="view-header">
          <div class="view-avatar">
            {{ viewingResume.employeeName?.charAt(0) || '?' }}
          </div>
          <div class="view-info">
            <h2>{{ viewingResume.employeeName }}</h2>
            <p class="view-position">{{ viewingResume.position || 'Должность не указана' }}</p>
            <p class="view-email">{{ viewingResume.employeeEmail }}</p>
          </div>
        </div>

        <!-- Summary -->
        <div v-if="viewingResume.summary" class="view-section">
          <h3>О себе</h3>
          <p>{{ viewingResume.summary }}</p>
        </div>

        <!-- Skills -->
        <div v-if="viewingResume.skills?.length" class="view-section">
          <h3>Ключевые навыки</h3>
          <div class="view-skills">
            <div v-for="(skill, idx) in viewingResume.skills" :key="idx" class="view-skill">
              <span class="skill-name">{{ skill.name }}</span>
              <span class="skill-level">{{ skill.level }}</span>
              <span v-if="skill.years" class="skill-years">{{ skill.years }} лет</span>
            </div>
          </div>
        </div>

        <!-- Experience -->
        <div v-if="viewingResume.experience?.length" class="view-section">
          <h3>Опыт работы</h3>
          <div v-for="(exp, idx) in viewingResume.experience" :key="idx" class="view-experience">
            <div class="exp-company">{{ exp.company }}</div>
            <div class="exp-position-date">
              <span>{{ exp.position }}</span>
              <span class="exp-period">{{ exp.startDate }} - {{ exp.endDate || 'по настоящее время' }}</span>
            </div>
            <p v-if="exp.description" class="exp-description">{{ exp.description }}</p>
            <div v-if="exp.projects?.length" class="exp-projects-view">
              <strong>Проекты:</strong>
              <ul>
                <li v-for="(proj, pidx) in exp.projects" :key="pidx">
                  <strong>{{ proj.name }}</strong>
                  <span v-if="proj.description">: {{ proj.description }}</span>
                </li>
              </ul>
            </div>
          </div>
        </div>

        <!-- Education -->
        <div v-if="viewingResume.education?.length" class="view-section">
          <h3>Образование</h3>
          <div v-for="(edu, idx) in viewingResume.education" :key="idx" class="view-education">
            <div class="edu-institution">{{ edu.institution }} <span v-if="edu.year">({{ edu.year }})</span></div>
            <div class="edu-degree">{{ edu.degree }}<span v-if="edu.field">, {{ edu.field }}</span></div>
          </div>
        </div>

        <!-- Certifications -->
        <div v-if="viewingResume.certifications?.length" class="view-section">
          <h3>Сертификаты</h3>
          <div v-for="(cert, idx) in viewingResume.certifications" :key="idx" class="view-cert">
            <span class="cert-name">{{ cert.name }}</span>
            <span v-if="cert.issuer" class="cert-issuer">{{ cert.issuer }}</span>
            <span v-if="cert.year" class="cert-year">({{ cert.year }})</span>
          </div>
        </div>

        <!-- Languages -->
        <div v-if="viewingResume.languages?.length" class="view-section">
          <h3>Языки</h3>
          <div class="view-languages">
            <div v-for="(lang, idx) in viewingResume.languages" :key="idx" class="view-lang">
              <span class="lang-name">{{ lang.language }}</span>
              <span class="lang-level">{{ lang.level }}</span>
            </div>
          </div>
        </div>
      </div>

      <template #footer>
        <el-button @click="viewDialogVisible = false">Закрыть</el-button>
        <el-button type="primary" @click="exportPdf(viewingResume)">
          <svg viewBox="0 0 24 24" fill="currentColor" width="14" height="14" style="margin-right: 6px;">
            <path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/>
          </svg>
          Скачать PDF
        </el-button>
        <el-button type="warning" @click="viewDialogVisible = false; openEditDialog(viewingResume)">
          <svg viewBox="0 0 24 24" fill="currentColor" width="14" height="14" style="margin-right: 6px;">
            <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
          </svg>
          Редактировать
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.resumes-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #0a0a1a 0%, #1a1a3a 50%, #0d0d2b 100%);
  padding: 20px;
}

.glass-card {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 16px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 30px;
  margin-bottom: 20px;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 20px;
}

.page-title {
  display: flex;
  align-items: center;
  gap: 12px;
  margin: 0;
  font-size: 24px;
  color: #fff;
}

.page-title svg {
  color: #60a5fa;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.search-input {
  width: 300px;
}

.btn-back {
  display: flex;
  align-items: center;
  gap: 8px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.2);
  color: #fff;
  padding: 10px 20px;
  border-radius: 10px;
}

.btn-back:hover {
  background: rgba(255, 255, 255, 0.15);
}

.resumes-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 20px;
  min-height: 200px;
}

.empty-state {
  grid-column: 1 / -1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px;
  color: rgba(255, 255, 255, 0.5);
}

.empty-state svg {
  opacity: 0.3;
  margin-bottom: 20px;
}

.resume-card {
  padding: 24px;
  transition: all 0.3s ease;
}

.resume-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 40px rgba(96, 165, 250, 0.15);
}

.resume-header {
  display: flex;
  gap: 16px;
  margin-bottom: 16px;
}

.avatar {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: linear-gradient(135deg, #3b82f6, #8b5cf6);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  font-weight: bold;
  color: #fff;
}

.info h3 {
  margin: 0;
  color: #fff;
  font-size: 18px;
}

.info .position {
  margin: 4px 0;
  color: #60a5fa;
  font-size: 14px;
}

.info .email {
  margin: 0;
  color: rgba(255, 255, 255, 0.5);
  font-size: 12px;
}

.resume-summary {
  margin-bottom: 16px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 14px;
  line-height: 1.5;
}

.resume-skills {
  margin-bottom: 16px;
}

.skills-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.skill-tag {
  background: rgba(59, 130, 246, 0.2);
  color: #60a5fa;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
}

.skill-more {
  color: rgba(255, 255, 255, 0.5);
  font-size: 12px;
}

.resume-actions {
  display: flex;
  gap: 8px;
  padding-top: 16px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

/* Dialog Styles */
.resume-dialog :deep(.el-dialog),
.view-dialog :deep(.el-dialog) {
  background: linear-gradient(145deg, #2d2b55 0%, #1e1b4b 100%) !important;
  border-radius: 16px !important;
  border: 1px solid rgba(139, 92, 246, 0.3) !important;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.8) !important;
  backdrop-filter: none !important;
}

.resume-dialog :deep(.el-dialog__header),
.view-dialog :deep(.el-dialog__header) {
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.resume-dialog :deep(.el-dialog__title),
.view-dialog :deep(.el-dialog__title) {
  color: #fff;
}

.resume-dialog :deep(.el-dialog__body),
.view-dialog :deep(.el-dialog__body) {
  max-height: 70vh;
  overflow-y: auto;
}

.form-section {
  margin-bottom: 20px;
}

.add-row {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  align-items: center;
}

.items-list {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 12px;
}

.projects-section {
  margin-top: 10px;
  padding: 10px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
}

.experience-list {
  margin-top: 15px;
}

.experience-item {
  padding: 12px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  margin-bottom: 10px;
}

.exp-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 8px;
}

.exp-dates {
  color: rgba(255, 255, 255, 0.5);
  font-size: 12px;
  margin-left: auto;
}

.exp-projects {
  margin-top: 8px;
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.edu-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 12px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 6px;
  margin-bottom: 8px;
  color: rgba(255, 255, 255, 0.8);
}

/* View Dialog Styles */
.resume-view {
  color: #fff;
}

.view-header {
  display: flex;
  gap: 20px;
  margin-bottom: 24px;
  padding-bottom: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.view-avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: linear-gradient(135deg, #3b82f6, #8b5cf6);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 32px;
  font-weight: bold;
  color: #fff;
  flex-shrink: 0;
}

.view-info h2 {
  margin: 0 0 8px 0;
  font-size: 24px;
}

.view-info .view-position {
  color: #60a5fa;
  margin: 0 0 4px 0;
  font-size: 16px;
}

.view-info .view-email {
  color: rgba(255, 255, 255, 0.5);
  margin: 0;
  font-size: 14px;
}

.view-section {
  margin-bottom: 24px;
}

.view-section h3 {
  color: #60a5fa;
  margin: 0 0 12px 0;
  font-size: 16px;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.view-section > p {
  color: rgba(255, 255, 255, 0.85);
  line-height: 1.6;
  margin: 0;
}

.view-skills {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.view-skill {
  display: flex;
  align-items: center;
  gap: 8px;
  background: rgba(59, 130, 246, 0.15);
  padding: 8px 16px;
  border-radius: 8px;
  border: 1px solid rgba(59, 130, 246, 0.3);
}

.view-skill .skill-name {
  font-weight: 500;
  color: #fff;
}

.view-skill .skill-level {
  color: #60a5fa;
  font-size: 13px;
}

.view-skill .skill-years {
  color: rgba(255, 255, 255, 0.5);
  font-size: 12px;
}

.view-experience {
  background: rgba(255, 255, 255, 0.05);
  padding: 16px;
  border-radius: 12px;
  margin-bottom: 12px;
  border-left: 3px solid #60a5fa;
}

.view-experience .exp-company {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 4px;
}

.view-experience .exp-position-date {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.view-experience .exp-position-date span:first-child {
  color: #60a5fa;
}

.view-experience .exp-period {
  color: rgba(255, 255, 255, 0.5);
  font-size: 13px;
}

.view-experience .exp-description {
  color: rgba(255, 255, 255, 0.75);
  margin: 8px 0;
  line-height: 1.5;
}

.exp-projects-view {
  margin-top: 12px;
  padding-top: 12px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.exp-projects-view ul {
  margin: 8px 0 0 0;
  padding-left: 20px;
}

.exp-projects-view li {
  margin-bottom: 4px;
  color: rgba(255, 255, 255, 0.8);
}

.view-education {
  padding: 12px 16px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  margin-bottom: 8px;
}

.view-education .edu-institution {
  font-weight: 500;
  margin-bottom: 4px;
}

.view-education .edu-degree {
  color: rgba(255, 255, 255, 0.7);
  font-size: 14px;
}

.view-cert {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 14px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  margin-bottom: 8px;
}

.view-cert .cert-name {
  font-weight: 500;
}

.view-cert .cert-issuer {
  color: #60a5fa;
  font-size: 14px;
}

.view-cert .cert-year {
  color: rgba(255, 255, 255, 0.5);
  font-size: 13px;
}

.view-languages {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.view-lang {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 16px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
}

.view-lang .lang-name {
  font-weight: 500;
}

.view-lang .lang-level {
  color: rgba(255, 255, 255, 0.6);
  font-size: 13px;
}

.resume-card {
  cursor: pointer;
}
</style>

<style>
/* Global styles for resume dialogs - override Element Plus defaults */
.resume-view-dialog {
  background: linear-gradient(145deg, #2d2b55 0%, #1e1b4b 100%) !important;
  backdrop-filter: none !important;
  -webkit-backdrop-filter: none !important;
  border-radius: 16px !important;
  border: 1px solid rgba(139, 92, 246, 0.3) !important;
}

.resume-view-dialog .el-dialog__header {
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.resume-view-dialog .el-dialog__title {
  color: #fff;
}

.resume-view-dialog .el-dialog__body {
  max-height: 70vh;
  overflow-y: auto;
}
</style>
